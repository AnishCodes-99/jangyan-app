import os
from PIL import Image

def generate_icons():
    src_path = 'JanGyan Logo.png'
    img = Image.open(src_path).convert('RGBA')

    # Target android mipmaps
    mipmap_sizes = {
        'android/app/src/main/res/mipmap-mdpi': 48,
        'android/app/src/main/res/mipmap-hdpi': 72,
        'android/app/src/main/res/mipmap-xhdpi': 96,
        'android/app/src/main/res/mipmap-xxhdpi': 144,
        'android/app/src/main/res/mipmap-xxxhdpi': 192,
    }

    for folder, size in mipmap_sizes.items():
        os.makedirs(folder, exist_ok=True)
        resized = img.resize((size, size), Image.Resampling.LANCZOS)
        out_path = os.path.join(folder, 'ic_launcher.png')
        resized.save(out_path, format='PNG')
        print(f'Wrote {out_path} ({size}x{size})')

        # Also provide launch_image for splash in mipmap
        launch_out = os.path.join(folder, 'launch_image.png')
        resized.save(launch_out, format='PNG')
        print(f'Wrote {launch_out} ({size}x{size})')

    # Drawables
    for drawable_folder in ['android/app/src/main/res/drawable', 'android/app/src/main/res/drawable-v21']:
        os.makedirs(drawable_folder, exist_ok=True)
        splash_img = img.resize((256, 256), Image.Resampling.LANCZOS)
        splash_path = os.path.join(drawable_folder, 'launch_image.png')
        splash_img.save(splash_path, format='PNG')
        print(f'Wrote {splash_path} (256x256)')

    # Web icons
    web_icons = {
        'web/icons/Icon-192.png': (192, 192),
        'web/icons/Icon-512.png': (512, 512),
        'web/icons/Icon-maskable-192.png': (192, 192),
        'web/icons/Icon-maskable-512.png': (512, 512),
        'web/favicon.png': (64, 64),
    }

    for path, (w, h) in web_icons.items():
        os.makedirs(os.path.dirname(path), exist_ok=True)
        res = img.resize((w, h), Image.Resampling.LANCZOS)
        res.save(path, format='PNG')
        print(f'Wrote {path} ({w}x{h})')

    # Favicon.ico
    ico_img = img.resize((32, 32), Image.Resampling.LANCZOS)
    ico_img.save('web/favicon.ico', format='ICO')
    print('Wrote web/favicon.ico')

    # Assets & Website
    img.save('assets/images/logo.png', format='PNG')
    img.save('website/assets/logo.png', format='PNG')
    img.save('web/logo.png', format='PNG')
    print('Updated assets/images/logo.png, website/assets/logo.png, web/logo.png')

if __name__ == '__main__':
    generate_icons()
