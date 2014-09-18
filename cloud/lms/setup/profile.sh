# Set an automatic timeout so we don't have idle boxes sitting around
echo "*********************************************************"
echo "*      Welcome to the Online Learning Environment       *"
echo "*                                                       *"
echo "*          This shell has a 5 minute timeout.           *"
echo "* You will be logged out after 5 minutes of inactivity. *"
echo "*********************************************************"
TMOUT=300
readonly TMOUT
export TMOUT
