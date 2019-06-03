default:
	@ruby -r "`pwd`/Builder.rb" -e "Builder.perform()"

# See why we need this: https://stackoverflow.com/a/6273809/1418981
%:
	@ruby -r "`pwd`/Builder.rb" -e "Builder.perform()" $@ $(toolchain)
