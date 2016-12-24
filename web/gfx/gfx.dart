library gfx;

import 'dart:html' as html;
import 'dart:math';

part 'web/canvas2d.dart';
part 'web/renderer.dart';
part 'web/shapes.dart';
part 'renderer.dart';
part 'renderers.dart';
part 'renderable.dart';
part 'scene.dart';
part 'color.dart';

void withContext(html.CanvasRenderingContext2D ctx, f(CanvasRenderingContext2D)) => f(ctx);
