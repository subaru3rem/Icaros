import qrcode

price_tag = qrcode.make("192.168.10.50")
price_tag.save("hello-world.png")