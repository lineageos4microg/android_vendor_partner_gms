import subprocess


user_name = 'Updater Robot'
user_email = 'robot@nowhere.invalid'


def add_commit_push(directory: str, message: str):
    diff = subprocess.run(['git', 'diff', '--cached', '--exit-code'], capture_output=True, text=True)
    if diff.returncode != 0:
        status = subprocess.run(['git', 'status'], capture_output=True, text=True)
        raise Exception('Unknown staged changes found: {}'.format(status.stdout))

    subprocess.run(['git', 'add', '--all', directory], check=True)
    subprocess.run(['git', '-c', 'user.name={}'.format(user_name), '-c', 'user.email={}'.format(user_email),
                    'commit', '--message', message])
    subprocess.run(['git', 'push'])
