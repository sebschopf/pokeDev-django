# languages/config/display_names.py

LIBRARY_DISPLAY_NAMES = {
    "capn-proto-pour-java-capnproto-java": "Cap'n Proto pour Java",
    "capn-proto-pour-python-pycapnp": "Cap'n Proto pour Python",
    "capn-proto-pour-go-capnproto-go": "Cap'n Proto pour Go",
    "capn-proto-pour-javascript-capnproto-js": "Cap'n Proto pour JavaScript",
    "capn-proto-pour-rust-capnproto-rust": "Cap'n Proto pour Rust",
    "fake-f-make": "FAKE (F# Make)",
    "otp-open-telecom-platform": "OTP (Open Telecom Platform)",
    "love": "LÖVE",
    "bootstrap-anciennement": "Bootstrap (anciennement)",
    # les autres si il y en a
}

def get_display_name(slug, default_name):
    """Obtient le nom d'affichage pour un slug donné"""
    return LIBRARY_DISPLAY_NAMES.get(slug, default_name)