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
        rect.center = self._window.get_rect().center
        self._graphics_data.append((background, rect, 0))
        self._update_rects.append(rect)

        start_game = ResourceManager.get_graphics(ResourceGraphics.BUTTON)
        rect = start_game.get_rect()
        rect.center = (1000, 300)
        self._graphics_data.append((start_game, rect, 0))
        self._update_rects.append(rect)

        settings = ResourceManager.get_graphics(ResourceGraphics.BUTTON)
        rect = settings.get_rect()
        rect.center = (1000, 375)
        self._graphics_data.append((settings, rect, 0))
        self._update_rects.append(rect)

        exit = ResourceManager.get_graphics(ResourceGraphics.BUTTON)
        rect = exit.get_rect()
        rect.center = (1000, 450)
        self._graphics_data.append((exit, rect, 0))
        self._update_rects.append(rect)

        font = pg.font.SysFont('SourceCodePro', 20)
        text = font.render('Exit', False, (255, 255, 255))
        rect = text.get_rect()
        rect.center = (1000, 450)
        self._graphics_data.append((text, rect, 1))
        self._update_rects.append(rect)

        self._update_display_order()

    def events(self, event: pg.event.Event) -> None:
        if event.type == pg.MOUSEBUTTONUP:
            rect = self._graphics_data[-1][1]
            if rect.collidepoint(*pg.mouse.get_pos()):
                pg.quit()
