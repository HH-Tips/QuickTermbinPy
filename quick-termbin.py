import os
import sys
import subprocess

def print_help():
    help_message = '''qtb <id> [-o <output_path>] [-b64] [-u]
    
OPTIONS:
    -o <output_path>    stores the file in the choosen location.
    -b64                decodes the file before to store it.
    -u                  decodes and unzip the file.
    -h                  to show this message.
'''
    print(help_message)

def wget(id, output_path):
    wget_cmd = ["wget", f"https://termbin.com/{id}", "-O", output_path]
    process = subprocess.run(wget_cmd, stdout=sys.stdout, stderr=sys.stderr)

    if (process.returncode != 0):
        raise Exception("wget: download failed.")

def base64_decode(path, output_path):
    if (path == output_path):
        subprocess.run(["mv", path, f"{path}b64"])
        path = f"{path}b64"

    base64_cmd = ["base64", "-d", path]
    output_file = open(output_path, "xt")
    process = subprocess.run(base64_cmd, stdout=output_file, stderr=sys.stderr)

    if (process.returncode != 0):
        raise Exception("base64: decode failed.")
    
    os.remove(path)

def unzipFile(path, output_path):
    if (path == output_path):
        subprocess.run(["mv", path, f"{path}.zip"])
        path = f"{path}.zip"
    
    unzip_cmd = ["unzip", "-n", path, "-d", output_path]
    process = subprocess.run(unzip_cmd, stdout=sys.stdout, stderr=sys.stderr)

    if (process.returncode != 0):
        raise Exception("unzip: extraction failed.")
    
    os.remove(path)

def main(args):
    try:
        if (len(args) < 1 or args[0] == "-h"):
            print_help()
            return

        id = args[0]

        output_path = None
        next_is_output_path = False
        decode_base64 = False
        unzip = False

        for i in range(1, len(args)):
            s = args[i]

            match s:
                case "-b64":
                    decode_base64 = True
                case "-u":
                    decode_base64 = True
                    unzip = True
                case "-o":
                    next_is_output_path = True
                case "-h":
                    raise ValueError
                case _:
                    if (not next_is_output_path):
                        raise Exception("Illegal Argument.")
                    output_path = s

        if (output_path is None):
            output_path = f"./{id}"

        wget(id, output_path)

        if (decode_base64):
            base64_decode(output_path, output_path)

        if (unzip):
            unzipFile(output_path, output_path)

    except Exception as err:
        print(f"{err}\n")
        print_help()

main(sys.argv[1:])