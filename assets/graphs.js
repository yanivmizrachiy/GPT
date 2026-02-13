function drawFunctionGraph(containerId, func) {
  const board = JXG.JSXGraph.initBoard(containerId, {
    boundingbox: [-10, 10, 10, -10],
    axis: true,
    showNavigation: false,
    showCopyright: false
  });
  board.create("functiongraph", [func]);
}
