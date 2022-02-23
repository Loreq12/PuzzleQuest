import pygame as pg

# STATES
from .base import BaseState
from .main_menu import MainMenuState

from ...resources import ResourceManager
from ...settings import ResourceGraphics


class IntroState(BaseState):

    def events(self, event: pg.event.Event) -> None:
        if event.type == pg.MOUSEBUTTONUP:
            self.next_state = MainMenuState

    def update_screen(self):
        if self.already_drawn:
            return

        background = ResourceManager.get_graphics(ResourceGraphics.SPLASH)
        rect = background.get_rect()
        rect.center = self._window.get_rect().center
        self._graphics_data.append((background, rect, 0))
        self._update_rects.append(rect)

        font = pg.font.SysFont('SourceCodePro', 24)
        text = font.render('Press any key to continue...', False, (255, 255, 255))
        rect = text.get_rect()
        rect.centerx = self._window.get_rect().centerx
        rect.centery = 670
        self._graphics_data.append((text, rect, 1))
        self._update_rects.append(rect)

        self._update_display_order()
