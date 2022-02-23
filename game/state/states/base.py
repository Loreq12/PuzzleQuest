from typing import Optional, Type

import pygame as pg

from abc import abstractmethod, ABC


class BaseState(ABC):

    def __init__(self, window: pg.Surface):
        self._window: pg.Surface = window
        self._window.fill((0, 0, 0))
        self.already_drawn: bool = False
        self.next_state: Optional[Type['BaseState']] = None

        # image to draw, position, z-index
        self._graphics_data: list[tuple[pg.Surface, pg.Rect, int]] = []
        self._update_rects: list[pg.Rect] = [self._window.get_rect()]

    def _update_display_order(self) -> None:
        # Sort by z-index
        self._graphics_data.sort(key=lambda x: x[2])
        for surface, rect, _ in self._graphics_data:
            self._window.blit(surface, rect)

        self.already_drawn = True

    def draw(self) -> None:
        if not self._update_rects:
            return
        pg.display.update(self._update_rects)
        self._update_rects = []

    @abstractmethod
    def update_screen(self) -> None:
        pass

    @abstractmethod
    def events(self, event: pg.event.Event) -> None:
        pass
