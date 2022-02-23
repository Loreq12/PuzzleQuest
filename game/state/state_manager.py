from typing import Type, Optional

import pygame as pg

from .states import BaseState, IntroState


class StateManager:

    def __init__(self, window: pg.Surface):
        # Base state after running game
        self._window: pg.Surface = window
        self._state: BaseState = IntroState(self._window)

    def _transition_to(self, state: Optional[Type[BaseState]]) -> None:
        if not state:
            return

        self._state = state(self._window)

    def events(self) -> None:
        for event in pg.event.get():
            self._state.events(event)

        self._transition_to(self._state.next_state)

    def render(self) -> None:
        self._state.update_screen()
        self._state.draw()

    def loop(self) -> None:
        pass
