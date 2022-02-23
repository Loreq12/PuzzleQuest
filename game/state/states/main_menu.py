import pygame as pg

# STATES
from . import BaseState

from ...resources import ResourceManager
from ...settings import ResourceGraphics


class MainMenuState(BaseState):
    def update_screen(self) -> None:
        if self.already_drawn:
            return

        background = ResourceManager.get_graphics(ResourceGraphics.MAIN_MENU)
        rect = background.get_rect()
        print(rect.center)
        rect.center = self._window.get_rect().center
        print(rect.center)
        self._graphics_data.append((background, rect, 0))
        self._update_rects.append(rect)

        self._update_display_order()

    def events(self, event: pg.event.Event) -> None:
        pass
