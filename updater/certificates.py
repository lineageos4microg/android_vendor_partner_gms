import subprocess


def get_apk_certificate(file: str):
    output = subprocess.check_output(['keytool', '-printcert', '-rfc', '-jarfile', file], text=True)
    lines = output.split("\n")
    return '\n'.join(lines[
        lines.index('-----BEGIN CERTIFICATE-----'):
        (lines.index('-----END CERTIFICATE-----')+1)
    ])

