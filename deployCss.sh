#! /bin/bash

#
# deployCss.sh
# Usage: use >./deployCss.sh to deploy all apps.  To deploy a specific resource,
# use >./deployCss.sh -a <ResourceName>, i.e. >./deployCss.sh -a LaunchPadStyles to
# deploy just LaunchPadStyles.
#

app="ALL"

while getopts :a: opt; do
    case $opt in
    a)
      app=$OPTARG
      ;;
    *)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
    esac
done

shift $((OPTIND - 1))

zipemup()
{
    echo "Zip up dashboards"
    EXCLUDE="*.git* *.svn* *.DS_Store *.scss"
    echo "Excluding $EXCLUDE"
    # Zip Dashboards excluding .git and .svn dirs
    sfdc -z
}

if [ "$app" == "ALL" -a -d resources/LaunchPadStyles ];  then
    zipemup
    ~/.vim/sfdc_plugin/SfDeploy.sh ./src/staticresources/LaunchPadStyles.resource
    ~/.vim/sfdc_plugin/SfDeploy.sh ./src/staticresources/MobileMerchants.resource
    ~/.vim/sfdc_plugin/SfDeploy.sh ./src/staticresources/GenericResources.resource
    ~/.vim/sfdc_plugin/SfDeploy.sh ./src/staticresources/LetsBonusResources.resource
    ~/.vim/sfdc_plugin/SfDeploy.sh ./src/staticresources/DealWizardResources.resource
    # ~/.vim/sfdc_plugin/SfDeploy.sh ./src/staticresources/IswResources.resource
elif [ -d resources/$app ]; then
    zipemup
    ~/.vim/sfdc_plugin/SfDeploy.sh ./src/staticresources/$app.resource
else
    echo "Resource $app not found."
fi