import os

import pygame as pg

from .settings import ResourceGraphics


class ResourceManager:

    _graphics: dict[str, pg.Surface] = {}

    @classmethod
    def get_graphics(cls, name: ResourceGraphics) -> pg.Surface:
        graphics = cls._graphics.get(name.value)
        if graphics:
            return graphics
        graphics = pg.image.load(os.path.join('game', 'resources', name.value)).convert_alpha()
        cls._graphics[name.value] = graphics
        return graphics
