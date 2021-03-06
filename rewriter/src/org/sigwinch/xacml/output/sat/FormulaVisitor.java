/*
 * Created on May 28, 2005
 */
package org.sigwinch.xacml.output.sat;

import org.sigwinch.xacml.tree.VariableReference;

/**
 * @author graham
 */
public interface FormulaVisitor {
    public void visitTrue(PrimitiveBoolean t);

    public void visitFalse(PrimitiveBoolean f);

    public void visitAnd(And and);

    public void visitOr(Or or);

    public void visitNot(Not not);

    public void visitVariable(VariableReference ref);

    public void visitEquivalence(Equivalence equivalence);

    public void visitImplication(Implication implication);
}

// arch-tag: FormulaVisitor.java May 28, 2005 12:47:58 AM
