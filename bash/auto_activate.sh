# various auto-activate scripts

source $(dirname $BASH_SOURCE)/upfind.sh
source $(dirname $BASH_SOURCE)/relpath.sh

_java_set_home() {
	local vers=$1
	if [ "$(uname -s)" = "Darwin" ]; then
		[[ "$vers" != "1.8.0" ]] && vers="-$vers"
		local dir=`ls -dt /Library/Java/JavaVirtualMachines/jdk${vers}* | head -1`
		dir=${dir}Contents/Home
		[ -d "$dir" ] && JAVA_HOME=$dir
	elif [ "$(uname -s)" = "Linux" ]; then
		local dir="/usr/lib/jvm/java-${vers}-openjdk"
		[ -d "$dir" ] && JAVA_HOME=$dir
	fi
	if [[ -d $JAVA_HOME ]]; then
		msg="JAVA_HOME=${JAVA_HOME}"
		export JAVA_HOME
	else
		unset JAVA_HOME
		echo "Error: JAVA_HOME could not be set"
	fi
}
_java_auto_activate() {
	unset msg

	# unset if PWD (common parent) is parent of JSET_PATH
	if [[  -n $JSET_PATH && -n $JAVA_HOME ]]; then
		local common_parent=$(printf "%s\n%s\n" "$JSET_PATH" "$PWD" | sed -e 'N;s/^\(.*\).*\n\1.*$/\1/')
		if [[  ! $common_parent =~ ^$JSET_PATH ]]; then
			msg="JAVA_HOME=(unset)"
			unset JAVA_HOME && unset JSET_PATH
			if [[ -n $JSET_OLD_PATH ]]; then
				export PATH=$JSET_OLD_PATH
				unset JSET_OLD_PATH
			fi
		fi
	fi

	local java14=$(upfind .java14)
	local java11=$(upfind .java11)
	local java8=$(upfind .java8)
	# if both then deeper (longer) dir has precedence; if both are same dir then use later
	if [[ -e $java14 && -e $java11 ]]; then
		[[ $(dirname $java14) =~ ^$(dirname $java11) ]] && unset java11 || unset java14
	fi
	if [[ -e $java11 && -e $java8 ]]; then
		[[ $(dirname $java11) =~ ^$(dirname $java8) ]] && unset java8 || unset java11
	fi
	if [[ -e $java14 && -e $java8 ]]; then
		[[ $(dirname $java14) =~ ^$(dirname $java8) ]] && unset java8 || unset java14
	fi
	[[ $java14 ]] && local dir=$(dirname $java14) && local vers='14'
	[[ $java11 ]] && local dir=$(dirname $java11) && local vers='11'
	[[ $java8 ]]  && local dir=$(dirname $java8)  && local vers='1.8.0'

	# if $dir is newer (JSET_PATH is parent of $dir) then unset
	if [[ $dir =~ ^$JSET_PATH/ ]]; then
		unset JAVA_HOME && unset JSET_PATH
	fi

	if [[ -n $dir && -z "$JAVA_HOME" ]]; then
		JSET_PATH=$dir
		_java_set_home $vers

		if [ "$(uname -s)" = "Linux" ]; then
			if [[ -n $JSET_OLD_PATH ]]; then
				PATH=$JSET_OLD_PATH
			fi
			JSET_OLD_PATH=$PATH
			export PATH=$JAVA_HOME/bin:$PATH
		fi
	fi

	[ "$msg" ] && echo "$(tput bold)$msg$(tput sgr0)"
}

# NOTE: this is not compatible w `pipenv shell` but I don't care bc I don't use it
_pipenv_auto_activate() {
	unset msg

	# _PIPENV_ACT_PATH -- this is the path at which pipenv was activated,
	#  if we go above this path, then deactivate
	if [ -d "$_PIPENV_ACT_PATH" ]; then
		_base=$(basename $_PIPENV_ACT_PATH)
		if [[ ! $PWD/ =~ ^$_PIPENV_ACT_PATH/ ]]; then
			msg="Deactivating \`$VIRTUAL_ENV\`"
			deactivate
			unset _PIPENV_ACT_PATH
		fi
	fi

	local _f=$(upfind Pipfile.lock)
	if [ -f "$_f" ]; then
		local _env=$(cd $(dirname $_f) && PIPENV_VERBOSITY=-1 pipenv --venv)
		[ -d "$_env" ] && _PIPENV_ACT_PATH=$(dirname $_f)

		# Check to see if already activated to avoid redundant activating
		if [ -n "$_PIPENV_ACT_PATH" ] && [ "$VIRTUAL_ENV" != "$_env" ]; then
			VIRTUAL_ENV_DISABLE_PROMPT=1 # we'll do the prompt ourselveds
			msg="Activating \`$_env\`"
			source $_env/bin/activate
		fi
	fi

	unset VENV
	if [ -n "$VIRTUAL_ENV" ] && [ -n "$_PIPENV_ACT_PATH" ]; then
		# Display rel path to pipenv root dir in prompt
		local t="$(basename $_PIPENV_ACT_PATH)"
		local p="$(relpath "$PWD" "$_PIPENV_ACT_PATH")"
		#[ "$p" = "." ] && p="" || p="$p/"
		p="$t" # just use name, use "$t:$p" if entire (rel) path is desired
		VENV="(\[$(tput sitm)\]$p\[$(tput ritm)\]) " # italicize
	fi

	[ "$msg" ] && echo "$(tput bold)$msg$(tput sgr0)"
}

_conda_auto_activate() {
	# For conda activate, must add this on every prompt (not just pwd changes)
	# conda can be activated w/o changing dirs (conda [de]activate ..)
	#unset VENV && [ "$CONDA_DEFAULT_ENV" ] && VENV="(${CONDA_DEFAULT_ENV}) "

	# _CONDA_ENV_ACT_PATH -- this is the path at which conda env was activated,
	#  if we go above this path, then deactivate
	if [ -d "$_CONDA_ENV_ACT_PATH" ]; then
		_base=$(basename $_CONDA_ENV_ACT_PATH)
		if [[ ! $PWD/ =~ ^$_CONDA_ENV_ACT_PATH/ ]]; then
			msg="Deactivating \`$CONDA_DEFAULT_ENV\`"
			conda deactivate
			unset _CONDA_ENV_ACT_PATH
		fi
	fi

	local _env
	_f=$(upfind .conda.env)
	if [ -f "$_f" ]; then
		read -r _env <"$_f"
	fi
	if [ "$_env" ] && [ "$_env" != "$CONDA_DEFAULT_ENV" ]; then
		conda activate $_env
		_CONDA_ENV_ACT_PATH=$(dirname $_f)
	fi
}

_virtualenv_auto_activate() {
	# Deactivate if venv dir no longer exists OR not prefix of pwd
	if [ "$VIRTUAL_ENV" ]; then
		base=$(basename $VIRTUAL_ENV)
		if [ ! -d "$VIRTUAL_ENV" ] || [[ ! $PWD/ =~ ^$(dirname $VIRTUAL_ENV)/ ]]; then
			msg="Deactivating \`$VIRTUAL_ENV\`"
			deactivate
			unset _VENV_PATH
		fi
	fi

	# Check for symlink pointing to virtualenv
	if [ -L ".venv" ]; then
		# could be absolute or relative link, but the pwd is valid since we are in chpwd
		dir=`dirname $(readlink .venv)`
		base=`basename $(readlink .venv)`
		[ "$dir" = "." ] \
			&& _VENV_PATH="$(pwd -P)/$base" \
			|| _VENV_PATH="$(cd $dir >/dev/null && pwd -P)/$base"

	elif [ -d ".venv" ]; then
		_VENV_PATH=$(pwd -P)/.venv

	else
		_d=$(upfind .venv)
		[ -n "$_d" ] && _VENV_PATH=$_d
	fi

	# Check to see if already activated to avoid redundant activating
	if [ -n "$_VENV_PATH" ] && [ "$VIRTUAL_ENV" != "$_VENV_PATH" ]; then
		_VENV_NAME=$(basename `pwd`)
		VIRTUAL_ENV_DISABLE_PROMPT=1
		msg="Activating \`$VIRTUAL_ENV\`"
		source $_VENV_PATH/bin/activate
	fi

	VENV=
	if [ -n "$VIRTUAL_ENV" ]; then
		local _h=$(dirname $VIRTUAL_ENV)
		local _t=$(basename $VIRTUAL_ENV)
		p="$(relpath $PWD $_h)"
		[ "$p" = "" ] && p="."
		VENV="(\[$(tput sitm)\]$p\[$(tput ritm)\]) " # italicize
	fi
}
