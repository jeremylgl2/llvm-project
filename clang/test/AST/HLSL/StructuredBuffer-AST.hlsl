// RUN: %clang_cc1 -triple dxil-pc-shadermodel6.0-library -x hlsl -ast-dump -DEMPTY %s | FileCheck -check-prefix=EMPTY %s
// RUN: %clang_cc1 -triple dxil-pc-shadermodel6.0-library -x hlsl -ast-dump %s | FileCheck %s


// This test tests two different AST generations. The "EMPTY" test mode verifies
// the AST generated by forward declaration of the HLSL types which happens on
// initializing the HLSL external AST with an AST Context.

// The non-empty mode has a use that requires the StructuredBuffer type be complete,
// which results in the AST being populated by the external AST source. That
// case covers the full implementation of the template declaration and the
// instantiated specialization.

// EMPTY: ClassTemplateDecl 0x{{[0-9A-Fa-f]+}} <<invalid sloc>> <invalid sloc> implicit StructuredBuffer
// EMPTY-NEXT: TemplateTypeParmDecl 0x{{[0-9A-Fa-f]+}} <<invalid sloc>> <invalid sloc> typename depth 0 index 0 element_type
// EMPTY-NEXT: CXXRecordDecl 0x{{[0-9A-Fa-f]+}} <<invalid sloc>> <invalid sloc> implicit <undeserialized declarations> class StructuredBuffer
// EMPTY-NEXT: FinalAttr 0x{{[0-9A-Fa-f]+}} <<invalid sloc>> Implicit final

// There should be no more occurrences of StructuredBuffer
// EMPTY-NOT: {{[^[:alnum:]]}}StructuredBuffer

#ifndef EMPTY

StructuredBuffer<float> Buffer;

#endif

// CHECK: ClassTemplateDecl 0x{{[0-9A-Fa-f]+}} <<invalid sloc>> <invalid sloc> implicit StructuredBuffer
// CHECK-NEXT: TemplateTypeParmDecl 0x{{[0-9A-Fa-f]+}} <<invalid sloc>> <invalid sloc> typename depth 0 index 0 element_type
// CHECK-NEXT: CXXRecordDecl 0x{{[0-9A-Fa-f]+}} <<invalid sloc>> <invalid sloc> implicit class StructuredBuffer definition

// CHECK: FinalAttr 0x{{[0-9A-Fa-f]+}} <<invalid sloc>> Implicit final
// CHECK-NEXT: FieldDecl 0x{{[0-9A-Fa-f]+}} <<invalid sloc>> <invalid sloc> implicit __handle '__hlsl_resource_t
// CHECK-SAME{LITERAL}: [[hlsl::resource_class(SRV)]]
// CHECK-SAME{LITERAL}: [[hlsl::raw_buffer]]
// CHECK-SAME{LITERAL}: [[hlsl::contained_type(element_type)]]
// CHECK-NEXT: HLSLResourceAttr 0x{{[0-9A-Fa-f]+}} <<invalid sloc>> Implicit RawBuffer

// CHECK: CXXMethodDecl 0x{{[0-9A-Fa-f]+}} <<invalid sloc>> <invalid sloc> operator[] 'const element_type &(unsigned int) const'
// CHECK-NEXT: ParmVarDecl 0x{{[0-9A-Fa-f]+}} <<invalid sloc>> <invalid sloc> Idx 'unsigned int'
// CHECK-NEXT: CompoundStmt 0x{{[0-9A-Fa-f]+}} <<invalid sloc>>
// CHECK-NEXT: ReturnStmt 0x{{[0-9A-Fa-f]+}} <<invalid sloc>>
// CHECK-NEXT: MemberExpr 0x{{[0-9A-Fa-f]+}} <<invalid sloc>> 'element_type' lvalue .e 0x{{[0-9A-Fa-f]+}}
// CHECK-NEXT: CXXThisExpr 0x{{[0-9A-Fa-f]+}} <<invalid sloc>> 'const StructuredBuffer<element_type>' lvalue implicit this
// CHECK-NEXT: AlwaysInlineAttr 0x{{[0-9A-Fa-f]+}} <<invalid sloc>> Implicit always_inline

// CHECK-NEXT: CXXMethodDecl 0x{{[0-9A-Fa-f]+}} <<invalid sloc>> <invalid sloc> operator[] 'element_type &(unsigned int)'
// CHECK-NEXT: ParmVarDecl 0x{{[0-9A-Fa-f]+}} <<invalid sloc>> <invalid sloc> Idx 'unsigned int'
// CHECK-NEXT: CompoundStmt 0x{{[0-9A-Fa-f]+}} <<invalid sloc>>
// CHECK-NEXT: ReturnStmt 0x{{[0-9A-Fa-f]+}} <<invalid sloc>>
// CHECK-NEXT: MemberExpr 0x{{[0-9A-Fa-f]+}} <<invalid sloc>> 'element_type' lvalue .e 0x{{[0-9A-Fa-f]+}}
// CHECK-NEXT: CXXThisExpr 0x{{[0-9A-Fa-f]+}} <<invalid sloc>> 'StructuredBuffer<element_type>' lvalue implicit this
// CHECK-NEXT: AlwaysInlineAttr 0x{{[0-9A-Fa-f]+}} <<invalid sloc>> Implicit always_inline

// CHECK: ClassTemplateSpecializationDecl 0x{{[0-9A-Fa-f]+}} <<invalid sloc>> <invalid sloc> class StructuredBuffer definition

// CHECK: TemplateArgument type 'float'
// CHECK-NEXT: BuiltinType 0x{{[0-9A-Fa-f]+}} 'float'
// CHECK-NEXT: FinalAttr 0x{{[0-9A-Fa-f]+}} <<invalid sloc>> Implicit final
// CHECK-NEXT: FieldDecl 0x{{[0-9A-Fa-f]+}} <<invalid sloc>> <invalid sloc> implicit __handle '__hlsl_resource_t
// CHECK-SAME{LITERAL}: [[hlsl::resource_class(SRV)]]
// CHECK-SAME{LITERAL}: [[hlsl::raw_buffer]]
// CHECK-SAME{LITERAL}: [[hlsl::contained_type(float)]]
// CHECK-NEXT: HLSLResourceAttr 0x{{[0-9A-Fa-f]+}} <<invalid sloc>> Implicit RawBuffer
