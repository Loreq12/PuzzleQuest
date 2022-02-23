import pygame as pg

from .settings import ScreenResolution, Window
from .state import StateManager


class App:

    @staticmethod
    def _change_resolution(resolution: ScreenResolution, window: Window) -> pg.Surface:
        return pg.display.set_mode(resolution.value, pg.HWSURFACE | pg.DOUBLEBUF | window.value)

    def __init__(self):
        # PyGame init
        # pg.mixer.pre_init(44100, 16, 2, 4096)
        pg.init()
        pg.event.set_allowed([pg.QUIT, pg.KEYUP, pg.MOUSEBUTTONUP, pg.MOUSEMOTION])

        # Default resolution
        self.window: pg.Surface = self._change_resolution(ScreenResolution.HD, Window.WIDOWED)
        self.state_manager = StateManager(self.window)

    def run(self):
        clock = pg.time.Clock()
        while True:
            if not pg.get_init():
                return

            self.state_manager.events()
            self.state_manager.loop()
            self.state_manager.render()

            clock.tick(120)
