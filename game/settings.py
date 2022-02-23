from enum import Enum

import pygame


class ScreenResolution(Enum):
    SVGA = (800, 600)
    HD = (1280, 720)
    FULL_HD = (1920, 1080)


class Window(Enum):
    WIDOWED = pygame.SHOWN
    FULL_SCREEN = pygame.FULLSCREEN


class ResourceGraphics(Enum):
    SPLASH = 'splash_screen.jpg'
    MAIN_MENU = 'main_menu_screen.jpg'
    BUTTON = 'button.png'
    TEST = 'test_image.jpg'
