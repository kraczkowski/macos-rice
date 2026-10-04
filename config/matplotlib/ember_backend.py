"""matplotlib backend: the stock macOS one, restyled so plot windows match Ghostty.

Each figure window gets a see-through, blurred background in the Sunset Ember base colour and a
transparent title bar with no title. Selected by MPLBACKEND=module://ember_backend (see install.sh).
Saved images are not affected: they keep the solid background from matplotlibrc.
"""

import ctypes
import ctypes.util

import matplotlib
from matplotlib.backends.backend_macosx import FigureCanvasMac, FigureManagerMac

# Keep these three in step with config/ghostty/config.
BACKGROUND = (0x0A / 255, 0x16 / 255, 0x18 / 255)
OPACITY = 0.2
BLUR_RADIUS = 32

TITLE_HIDDEN = 1

objc = ctypes.CDLL(ctypes.util.find_library("objc"))
objc.objc_getClass.restype = ctypes.c_void_p
objc.objc_getClass.argtypes = [ctypes.c_char_p]
objc.sel_registerName.restype = ctypes.c_void_p
objc.sel_registerName.argtypes = [ctypes.c_char_p]
objc.class_replaceMethod.restype = ctypes.c_void_p
objc.class_replaceMethod.argtypes = [ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_char_p]

graphics = ctypes.CDLL(ctypes.util.find_library("CoreGraphics"))


def send(receiver, selector, *args, restype=ctypes.c_void_p, argtypes=()):
    """Call an Objective-C method. Each call needs its exact C signature on Apple silicon."""
    prototype = ctypes.CFUNCTYPE(restype, ctypes.c_void_p, ctypes.c_void_p, *argtypes)
    return prototype(("objc_msgSend", objc))(receiver, objc.sel_registerName(selector.encode()), *args)


# matplotlib's canvas view tells macOS it is opaque, which paints black behind transparent pixels.
_not_opaque = ctypes.CFUNCTYPE(ctypes.c_bool, ctypes.c_void_p, ctypes.c_void_p)(lambda view, selector: False)
objc.class_replaceMethod(objc.objc_getClass(b"View"), objc.sel_registerName(b"isOpaque"), _not_opaque, b"c@:")


def style_windows():
    """Restyle every window of this Python process; with this backend they are all figure windows."""
    app = send(objc.objc_getClass(b"NSApplication"), "sharedApplication")
    windows = send(app, "windows")
    tint = send(
        objc.objc_getClass(b"NSColor"), "colorWithSRGBRed:green:blue:alpha:", *BACKGROUND, OPACITY,
        argtypes=(ctypes.c_double,) * 4,
    )
    for index in range(send(windows, "count", restype=ctypes.c_ulong)):
        window = send(windows, "objectAtIndex:", index, argtypes=(ctypes.c_ulong,))
        send(window, "setOpaque:", False, restype=None, argtypes=(ctypes.c_bool,))
        send(window, "setBackgroundColor:", tint, restype=None, argtypes=(ctypes.c_void_p,))
        send(window, "setTitlebarAppearsTransparent:", True, restype=None, argtypes=(ctypes.c_bool,))
        send(window, "setTitleVisibility:", TITLE_HIDDEN, restype=None, argtypes=(ctypes.c_long,))
        # The same private call Ghostty uses for background-blur-radius.
        number = send(window, "windowNumber", restype=ctypes.c_long)
        graphics.CGSSetWindowBackgroundBlurRadius(graphics.CGSMainConnectionID(), number, BLUR_RADIUS)


# Nothing is painted behind the plot, so the window's tint and blur show through.
matplotlib.rcParams["axes.facecolor"] = "none"


class FigureManagerEmber(FigureManagerMac):
    def __init__(self, canvas, num):
        super().__init__(canvas, num)
        canvas.figure.patch.set_alpha(0)
        style_windows()

    def show(self):
        super().show()
        style_windows()


class FigureCanvasEmber(FigureCanvasMac):
    manager_class = FigureManagerEmber


FigureCanvas = FigureCanvasEmber
FigureManager = FigureManagerEmber
