param(
    [string] $Ref
)
# Pull an issue number from the current branch name and open
# it in the webbrowser. Only works if github (gh) is the remote origin, 
# and using the https url.
# tfaris 12.09.2015

if ($Ref)
{
    $b = "$(git branch | Select-String $Ref)"
}
else
{
    $b = $(git rev-parse --abbrev-ref HEAD)
}

$ghUrl = $(git config --get remote.origin.url)

&python -c "
import re
import sys
import webbrowser
import time
gh_url = sys.argv[1]
ref = sys.argv[2]
print('Origin: %s' % gh_url)
print('Ref   : %s' % ref)
try:
    issue = re.sub('[^\d]', '', ref.split('/')[1])
    int(issue)
    url = gh_url + '/issues/' + issue
    print('Opening %s...' % url)
    time.sleep(.5)
    webbrowser.open(url)
except (IndexError, ValueError):
    print('Cannot parse branch name %s as an issue. Opening tree...' % ref)
    url = gh_url + '/tree/' + ref
    webbrowser.open(url)
" "$ghUrl" "$b"
