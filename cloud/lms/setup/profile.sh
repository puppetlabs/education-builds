# Set an automatic timeout so we don't have idle boxes sitting around
echo "**********************************************************"
echo "*      Welcome to the Online Learning Environment        *"
echo "*                                                        *"
echo "*          This shell has a 15 minute timeout.           *"
echo "* You will be logged out after 15 minutes of inactivity. *"
echo "**********************************************************"
TMOUT=900
readonly TMOUT
export TMOUT
