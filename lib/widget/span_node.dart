import 'package:flutter/material.dart';

///the basic node
abstract class SpanNode {
  InlineSpan build();

  SpanNode? _parent;

  TextStyle? style;

  TextStyle? get parentStyle => _parent?.style;

  SpanNode? get parent => _parent;

  void _acceptParent(SpanNode node) {
    _parent = node;
  }
}

///this node will accept other SpanNode as children
abstract class ElementNode extends SpanNode {
  final List<SpanNode> children = [];

  void accept(SpanNode? node) {
    if (node != null) children.add(node);
    node?._acceptParent(this);
  }

  @override
  InlineSpan build() => childrenSpan;

  TextSpan get childrenSpan => TextSpan(
      children:
          List.generate(children.length, (index) => children[index].build()));
}

///the default concrete node for ElementNode
class ConcreteElementNode extends ElementNode {
  final String tag;

  ConcreteElementNode({this.tag = ''});

  @override
  InlineSpan build() => childrenSpan;
}

///text node only displays text
class TextNode extends SpanNode {
  final String text;
  final TextStyle style;

  TextNode({this.text = '', this.style = const TextStyle()});

  @override
  InlineSpan build() {
    return TextSpan(text: text, style: style.merge(parentStyle));
  }
}
