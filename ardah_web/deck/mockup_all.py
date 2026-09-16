"""Wrap every captured frame in a device shell, at deck and thumbnail sizes."""
import glob, os
from mockup import device

HERE = os.path.dirname(os.path.abspath(__file__))
frames = os.path.join(HERE, 'frames')
out = os.path.join(HERE, 'mock')
os.makedirs(out, exist_ok=True)

for f in sorted(glob.glob(os.path.join(frames, '*.png'))):
    name = os.path.basename(f)[:-4]
    device(f, 1150).save(os.path.join(out, name + '.png'))
    device(f, 640).save(os.path.join(out, name + '_sm.png'))
print('mockups:', len(glob.glob(os.path.join(out, '*.png'))))
