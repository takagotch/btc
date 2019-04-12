import os
import subprocess

dir = os.path.dirname(os.path.abspath(__file__))
while True:
  subprocess.run(['python', os.path.join(dir, 'peer.py')])


