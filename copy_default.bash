# the default binary files for which we can have a basic shell

# first of all, sshx, as this is the whole point of this exercise

mkdir ./bin

SSHX=$(which sshx)
cp $SSHX ./bin

# now, let's add some basic tools for the shell
# ls, pwd, echo, grep, cat, less, more, head, tail, sed, awk, cut, sort, uniq, wc, du, df

TOOLS="ls pwd echo grep cat less more head tail sed awk cut sort uniq wc which du df python3"
for tool in $TOOLS; do
  TOOL=$(which $tool)
  echo "Copying $TOOL to ./bin"
  
  cp $TOOL ./bin
done
