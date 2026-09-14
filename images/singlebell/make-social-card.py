"""The 1200 x 630 social card for singlebell.qmd, drawn from the current store frame.

    python3 images/singlebell/make-social-card.py

Run from the site root. Reads home.png (the 600 x 1303 site frame, itself scaled from
Marketing/screenshots/iphone-6.9/01-home.png in the app repo) and appicon.png, and
writes social-card.png beside them. The card wears the site's own palette
(_palette-wiring.scss: ground, writing, accent), not the app's, because it is the
site's card; the phone inside it is the app as it is.
"""
import os
from PIL import Image, ImageDraw, ImageFont

HERE = os.path.dirname(os.path.abspath(__file__))
GROUND, WRITING, MUTED, ACCENT = (14, 20, 18), (242, 243, 234), (184, 189, 181), (233, 213, 146)
W, H = 1200, 630

def font(path, size, index=0, axes=None):
    f = ImageFont.truetype(path, size, index=index)
    if axes:
        f.set_variation_by_axes(axes)
    return f

# New York is a variable face: optical size, weight, grade. Its default is the Display
# cut at 256, whose hairlines vanish at this size; the Large cut at a medium weight is
# what the page's own headings read as.
serif = font("/System/Library/Fonts/NewYork.ttf", 104, axes=[72, 500, 0])
# Avenir Next.ttc: 7 is Regular, 5 is Medium (0 is Bold).
sans = font("/System/Library/Fonts/Avenir Next.ttc", 30, index=7)
sans_accent = font("/System/Library/Fonts/Avenir Next.ttc", 30, index=5)

card = Image.new("RGB", (W, H), GROUND)
d = ImageDraw.Draw(card)

# The icon, at the size the page's hero draws it, with its corners rounded.
icon = Image.open(os.path.join(HERE, "appicon.png")).convert("RGB").resize((112, 112), Image.LANCZOS)
mask = Image.new("L", icon.size, 0)
ImageDraw.Draw(mask).rounded_rectangle((0, 0, 111, 111), radius=26, fill=255)
card.paste(icon, (92, 82), mask)

d.text((88, 214), "SingleBell", font=serif, fill=WRITING)
d.text((92, 332), "A kettlebell practice app for iPhone.", font=sans, fill=MUTED)
d.text((92, 374), "The day's practice, dealt each morning.", font=sans, fill=MUTED)
d.text((92, 458), "No account · no analytics · collects nothing", font=sans_accent, fill=ACCENT)

# The phone: the site's home frame, scaled to sit on the right and run off the foot.
frame = Image.open(os.path.join(HERE, "home.png")).convert("RGB")
pw = 310
ph = round(frame.height * pw / frame.width)
frame = frame.resize((pw, ph), Image.LANCZOS)
x, y, r = 782, 30, 44
phone = Image.new("RGB", (pw + 8, ph + 8), (52, 58, 55))
pm = Image.new("L", phone.size, 0)
ImageDraw.Draw(pm).rounded_rectangle((0, 0, pw + 7, ph + 7), radius=r + 4, fill=255)
fm = Image.new("L", frame.size, 0)
ImageDraw.Draw(fm).rounded_rectangle((0, 0, pw - 1, ph - 1), radius=r, fill=255)
phone.paste(frame, (4, 4), fm)
card.paste(phone, (x, y), pm)

out = os.path.join(HERE, "social-card.png")
card.save(out, optimize=True)
print("wrote", out, card.size)
