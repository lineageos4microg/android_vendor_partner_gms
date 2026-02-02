import urllib.request
from os import path

import certificates
import subprocess
import git
from sources import ApkRelease, fdroid_recommended_release

def create_update_issue(component: str, new_release: ApkRelease):
    print('Need to update {} to {}'.format(component, new_release.version_name))
    print('version_code {}'.format(new_release.version_code))

    # Now we'll call the github-cli function
    issue_title = 'Update {} to version {}'.format(component, new_release.version_name)
    issue_body = 'New version code is {}'.format(new_release.version_code)
    command = 'ghi open -m {} \n{}'.format(issue_title, issue_body)
    print('command: {}'.format(command))



def update_if_needed(module: str, release: ApkRelease):
    module_dir = path.abspath(path.join(path.dirname(__file__), '..', module))
    with open(path.join(module_dir, '.version_code'), 'r+') as version_code_file:
        version_code = int(version_code_file.read())
        if version_code < release.version_code:
            create_update_issue(module, release)
        elif version_code > release.version_code:
            print('{} ahead of suggested version ({} > {})'.format(module, version_code, release.version_code))
        elif version_code == release.version_code:
            print('{} up to date, version {}'.format(module, release.version_name))

fdroid_main_repo = 'https://www.f-droid.org/repo'
fdroid_microg_repo = 'https://microg.org/fdroid/repo'

update_if_needed('FakeStore', fdroid_recommended_release(fdroid_microg_repo, 'com.android.vending'))
update_if_needed('FDroid', fdroid_recommended_release(fdroid_main_repo, 'org.fdroid.fdroid'))
update_if_needed('FDroidPrivilegedExtension', fdroid_recommended_release(fdroid_main_repo, 'org.fdroid.fdroid.privileged'))
update_if_needed('GmsCore', fdroid_recommended_release(fdroid_microg_repo, 'com.google.android.gms'))
#update_if_needed('GsfProxy', fdroid_recommended_release(fdroid_microg_repo, 'com.google.android.gsf'))
