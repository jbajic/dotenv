" Vim syntax file for ArangoDB AQL (ArangoDB Query Language)
" Language: AQL (ArangoDB Query Language)
" Maintainer: Jure Bajic
" Latest Revision: 2025

if exists("b:current_syntax")
  finish
endif

" Case sensitivity
syn case ignore

" Keywords - High-level operations
syn keyword aqlKeyword FOR RETURN FILTER SEARCH SORT LIMIT LET COLLECT WINDOW INSERT UPDATE REPLACE REMOVE UPSERT WITH

" Additional keywords
syn keyword aqlKeyword AGGREGATE ALL ALL_SHORTEST_PATHS AND ANY ASC DESC DISTINCT FALSE GRAPH IN INTO K_PATHS K_SHORTEST_PATHS LIKE NONE NOT NULL OR OUTBOUND SHORTEST_PATH TRUE

" Context-dependent keywords (not reserved but keyword-like)
syn keyword aqlKeyword KEEP COUNT OPTIONS PRUNE TO

" Special variables (case-sensitive)
syn keyword aqlSpecial CURRENT NEW OLD

" Operators
syn keyword aqlOperator AND OR NOT
syn match aqlOperator "=="
syn match aqlOperator "!="
syn match aqlOperator ">="
syn match aqlOperator "<="
syn match aqlOperator ">"
syn match aqlOperator "<"
syn match aqlOperator "="
syn match aqlOperator "+"
syn match aqlOperator "-"
syn match aqlOperator "*"
syn match aqlOperator "/"
syn match aqlOperator "%"
syn match aqlOperator "&&"
syn match aqlOperator "||"
syn match aqlOperator "!"

" Comments
syn region aqlComment start="/\*" end="\*/" contains=aqlTodo
syn match aqlComment "//.*$" contains=aqlTodo
syn match aqlComment "--.*$" contains=aqlTodo

" Strings
syn region aqlString start='"' end='"' skip='\\"'
syn region aqlString start="'" end="'" skip="\\'"

" Numbers
syn match aqlNumber "\<[0-9]\+\([Ee][+-]\?[0-9]\+\)\?\>"
syn match aqlNumber "\<[0-9]\+\.[0-9]\+\([Ee][+-]\?[0-9]\+\)\?\>"
syn match aqlNumber "\<[0-9]\+\>"

" Booleans
syn keyword aqlBoolean true false

" Null
syn keyword aqlNull null

" Collection names (quoted with backticks or forward ticks)
syn region aqlCollection start="`" end="`" skip="\\`"
syn region aqlCollection start="´" end="´" skip="\\´"

" Variables (following AQL naming rules)
syn match aqlVariable "\<[a-zA-Z_][a-zA-Z0-9_]*\>"
syn match aqlVariable "\$[a-zA-Z][a-zA-Z0-9_]*\>"

" Functions (common AQL functions)
syn keyword aqlFunction LENGTH CONCAT SUBSTRING UPPER LOWER TRIM SPLIT JOIN
syn keyword aqlFunction IS_NULL IS_BOOL IS_NUMBER IS_STRING IS_ARRAY IS_OBJECT
syn keyword aqlFunction DOCUMENT EDGES VERTICES NEIGHBORS PATHS
syn keyword aqlFunction COUNT SUM AVG MIN MAX FIRST LAST UNIQUE
syn keyword aqlFunction DATE_NOW DATE_ISO8601 DATE_TIMESTAMP DATE_ADD DATE_SUBTRACT
syn keyword aqlFunction RAND RANDOM UUID
syn keyword aqlFunction L2_DISTANCE COSINE_SIMILARITY
syn keyword aqlFunction REMOVE_VALUE IS_SAME_COLLECTION
syn keyword aqlFunction APPROX_NEAR_L2 APPROX_NEAR_COSINE APPROX_NEAR_INNER_PRODUCT
syn keyword aqlFunction FLATTEN

" Graph traversal keywords
syn keyword aqlGraphTraversal INBOUND OUTBOUND ANY SHORTEST_PATH ALL_SHORTEST_PATHS K_SHORTEST_PATHS K_PATHS

" Nested queries in parentheses - must be defined before bracket regions
syn region aqlNestedParen start="(" end=")" contains=ALL

" Nested queries and attribute access in square brackets - handles both cases
syn region aqlNestedQuery start="\[" end="\]" contains=ALL

" Nested
syntax region aqlNested start="//{{{\s---" end="//}}}" fold contains=xFold

" Highlighting groups
hi def link aqlKeyword Statement
hi def link aqlSpecial Special
hi def link aqlOperator Operator
hi def link aqlComment Comment
hi def link aqlTodo Todo
hi def link aqlString String
hi def link aqlNumber Number
hi def link aqlBoolean Boolean
hi def link aqlNull Type
hi def link aqlCollection Identifier
hi def link aqlVariable Identifier
hi def link aqlFunction Function
hi def link aqlGraphTraversal Keyword
hi def link aqlNestedQuery Structure
hi def link aqlNestedParen Structure

let b:current_syntax = "aql" 
