import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

class KeyVisitor extends RecursiveAstVisitor<void> {
  final String className;
  bool insideClass = false;
  final keys = <String>[];

  KeyVisitor(this.className);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    if (node.name.lexeme == className) {
      insideClass = true;
      super.visitClassDeclaration(node);
      insideClass = false;
    }
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    if (insideClass && !node.isStatic) {
      keys.add(node.name.lexeme);
    }
    super.visitMethodDeclaration(node);
  }
}
