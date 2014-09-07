var helpersTests = [
  {
    name: "replace",
    tests: [
      {
        name:     "hello_there",
        source:   "Hello {name}! You have {count} new messages.",
        context:  { name: "Mick", count: 30 },
        expected: "Hello Mick! You have 30 new messages.",
        message: "should test a basic replace"
      }
    ]
  },
  {
    name: "if",
    tests: [
      {
        name:     "if helper with no body",
        source:   '{@if cond="{x}<{y}"/}',
        context:  { x: 2, y: 3 },
        expected: "",
        message: "should test if helper with no body and fail gracefully"
      },
      {
        name:     "if helper without else",
        source:   '{@if cond="{x}<{y}"}<div> X < Y </div>{/if}',
        context:  { x: 2, y: 3 },
        expected: "<div> X < Y </div>",
        message: "should test if helper without else"
      },
      {
        name:     "if helper with else block",
        source:   '{@if cond=" \'{x}\'.length && \'{y}\'.length "}<div> X and Y exists </div>{:else}<div> X and Y does not exists </div>{/if}',
        context:  {},
        expected: "<div> X and Y does not exists </div>",
        message: "should test if helper with else block"
      },
      {
        name:     "if helper with else using the or condition",
        source:   '{@if cond=" \'{x}\'.length || \'{y}\'.length "}<div> X or Y exists </div>{:else}<div> X or Y does not exists </div>{/if}',
        context:  { x: 1},
        expected: "<div> X or Y exists </div>",
        message: "should test if helper with else using the or condition"
      },
      {
        name:     "if helper with else using the and conditon",
        source:   '{@if cond="( \'{x}\'.length ) && ({x}<3)"}<div> X exists and is 1 </div>{:else}<div> x is not there </div>{/if}',
        context:  { x : 1},
        expected: "<div> X exists and is 1 </div>",
        message: "should test if helper with else usingt he and conditon"
      },
      {
        name:     "if helper using $idx",
        source:   '{#list}{@if cond="( {$idx} == 1 )"}<div>{y}</div>{/if}{/list}',
        context:  { x : 1, list: [ { y: 'foo' }, { y: 'bar'} ]},
        expected: "<div>bar</div>",
        message: "should test the if helper using $idx"
      }
    ]
  },
  {
    name: "math",
    tests: [
      {
        name:     "math/mod helper with zero as key value",
        source:   '<div>{@math key="0" method="mod" operand="16"/}</div>',
        context:  {},
        expected: "<div>0</div>",
        message: "testing math/mod helper with zero as key value"
      },
      {
         name:     "math/mod helper with zero as key value",
         source:   '<div>{@math key="0" method="mod" operand="-16"/}</div>',
         context:  {},
         expected: "<div>0</div>",
         message: "testing math/mod helper with zero as key value"
       },
      {
           name:     "math/mod helper with zero as key value and operand as variable as variable without quotes",
           source:   '<div>{@math key="0" method="mod" operand=y/}</div>',
           context:  { y: 4},
           expected: "<div>0</div>",
           message: "testing math/mod helper with zero as key value and operand as variable without quotes"
      },
      {
           name:     "math/mod helper with zero as key value  and operand as variable with quotes",
           source:   '<div>{@math key="0" method="mod" operand="{y}"/}</div>',
           context:  { y: 4},
           expected: "<div>0</div>",
           message: "testing math/mod helper with zero as key value  and operand as variable with quotes"
      },
      {
         name:     "math/mod helper with zero as operand value",
         source:   '<div>{@math key="0" method="mod" operand="0"/}</div>',
         context:  {},
         expected: "<div>NaN</div>",
         message: "testing math/mod helper with zero as operand value"
       },
       {
           name:     "math/mod helper with negative zero as operand value",
           source:   '<div>{@math key="0" method="mod" operand="-0"/}</div>',
           context:  {},
           expected: "<div>NaN</div>",
           message: "testing math/mod helper with negative zero as operand value"
       },
       {
         name:     "math/divide helper with zero as key value",
         source:   '<div>{@math key="0" method="divide" operand="16"/}</div>',
         context:  {},
         expected: "<div>0</div>",
         message: "testing math/divide helper with zero as key value"
       },
       {
          name:     "math/divide helper with zero as operand value",
          source:   '<div>{@math key="0" method="divide" operand="0"/}</div>',
          context:  {},
          expected: "<div>NaN</div>",
          message: "testing math/divide helper with zero as operand value"
        },
      {
        name:     "math helper mod numbers",
        source:   '<div>{@math key="16" method="mod" operand="4"/}</div>',
        context:  {},
        expected: "<div>0</div>",
        message: "testing math/mod helper with two numbers"
      },
      {
        name:     "math helper mod using $idx",
        source:   '{#list}<div>{@math key="{$idx}" method="mod" operand="5"/}</div>{/list}',
        context:  { list: [ { y: 'foo' } ]},
        expected: "<div>0</div>",
        message: "should test the math/mod helper using $idx"
      },
      {
         name:     "math helper mod using $idx without quotes with lizt size = 2",
         source:   '{#list}<div>{@math key="{$idx}" method="mod" operand="2"/}</div>{/list}',
         context:  { list: [ { y: 'foo' }, { y: "bar"} ]},
         expected: "<div>0</div><div>1</div>",
         message: "should test the math/mod helper using $idx without quotes with lizt size = 2"
       },
      {
        name:     "math helper mod using $idx without quotes",
        source:   '{#list}<div>{@math key=$idx method="mod" operand="5"/}</div>{/list}',
        context:  { list: [ { y: 'foo' } ]},
        expected: "<div>0</div>",
        message: "should test the math/mod helper using $idx without quotes"
      },
      {
        name:     "math helper mod using $idx without quotes with lizt size = 2",
        source:   '{#list}<div>{@math key=$idx method="mod" operand="2"/}</div>{/list}',
        context:  { list: [ { y: 'foo' }, { y: "bar"} ]},
        expected: "<div>0</div><div>1</div>",
        message: "should test the math/mod helper using $idx without quotes with lizt size = 2"
      },
      {
        name:     "math helper mod using $len",
        source:   '{#list}<div>{@math key="{$len}" method="mod" operand="5"/}</div>{/list}',
        context:  { list: [ { y: 'foo' } ]},
        expected: "<div>1</div>",
        message: "should test the math/mod helper using $len"
      },
      {
        name:     "math helper mod using $len without quotes",
        source:   '{#list}<div>{@math key=$len method="mod" operand="5"/}</div>{/list}',
        context:  { list: [ { y: 'foo' } ]},
        expected: "<div>1</div>",
        message: "should test the math/mod helper using $len without quotes"
      },
      {
        name:     "math helper subtract numbers",
        source:   '<div>{@math key="16" method="subtract" operand="4"/}</div>',
        context:  {},
        expected: "<div>12</div>",
        message: "testing math/subtract helper with two numbers"
      },
      {
        name:     "math helper add with key as negative number",
        source:   '<div>{@math key="-16" method="add" operand="4"/}</div>',
        context:  {},
        expected: "<div>-12</div>",
        message: "testing math/add helper with key as negative number"
      },
      {
        name:     "math helper subtract with key as negative number",
        source:   '<div>{@math key="-16" method="subtract" operand="4"/}</div>',
        context:  {},
        expected: "<div>-20</div>",
        message: "testing math/subtract helper with key as negative number"
      },
      {
        name:     "math helper multiply with key as negative number",
        source:   '<div>{@math key="-2" method="multiply" operand="4"/}</div>',
        context:  {},
        expected: "<div>-8</div>",
        message: "testing math/multiply helper with key as negative number"
      },
      {
        name:     "math helper multiply with key as negative number and variable operand without quotes",
        source:   '<div>{@math key="-2" method="multiply" operand=y/}</div>',
        context:  { y: 4},
        expected: "<div>-8</div>",
        message: "testing math/multiply helper with key as negative number  and variable operand without quotes"
      },
      {
         name:     "math helper multiply with key as negative number and variable operand with quotes",
         source:   '<div>{@math key="-2" method="multiply" operand="{y}"/}</div>',
         context:  { y: 4},
         expected: "<div>-8</div>",
         message:  "testing math/multiply helper with key as negative number and variable operand with quotes"
      },
      {
        name:     "math helper add negative numbers",
        source:   '<div>{@math key="-16" method="add" operand="-4"/}</div>',
        context:  {},
        expected: "<div>-20</div>",
        message: "testing math/add helper with negative numbers"
      },
      {
        name:     "math helper subtract negative numbers",
        source:   '<div>{@math key="-16" method="subtract" operand="-4"/}</div>',
        context:  {},
        expected: "<div>-12</div>",
        message: "testing math/subtract helper with negative numbers"
      },
      {
        name:     "math helper multiply negative numbers",
        source:   '<div>{@math key="-0" method="multiply" operand="-4"/}</div>',
        context:  {},
        expected: "<div>0</div>",
        message: "testing math/multiply helper with negative numbers"
      },
      {
         name:     "math helper blah operation",
         source:   '{@math key="-0" method="blah" operand="-4"/}',
         context:  {},
         expected: "",
         message: "math helper blah operation"
       },
      {
         name:     "math helper key as zero",
         source:   '<div>{@math key="0" method="subtract" operand="0"/}</div>',
         context:  {},
         expected: "<div>0</div>",
         message: "testing math helper with zero as the operand"
      },
      {
          name:     "math helper zero key",
          source:   '<div>{@math key="0" method="multiply" operand="0"/}</div>',
          context:  {},
          expected: "<div>0</div>",
          message: "testing math helper with zero key"
      },
      {
          name:     "math helper zero key and operand for divide",
          source:   '<div>{@math key="0" method="divide" operand="0"/}</div>',
          context:  {},
          expected: "<div>NaN</div>",
          message: "testing math helper with zero key and operand for divide"
      },
      {
        name:     "math helper zero operand",
        source:   '<div>{@math key="16" method="subtract" operand="0"/}</div>',
        context:  {},
        expected: "<div>16</div>",
        message: "testing math helper with zero as the operand"
      },
      {
        name:     "math helper subtract number and string",
        source:   '<div>{@math key="16" method="subtract" operand="doh"/}</div>',
        context:  {},
        expected: "<div>NaN</div>",
        message: "testing math/subtract helper with a number and a string"
      },
      {
        name:     "math helper add numbers",
        source:   '<div>{@math key="5" method="add" operand="4"/}</div>',
        context:  {},
        expected: "<div>9</div>",
        message: "testing math/add helper with two numbers"
      },
      {
        name:     "math helper multiply numbers",
        source:   '<div>{@math key="5" method="multiply" operand="4"/}</div>',
        context:  {},
        expected: "<div>20</div>",
        message: "testing math/multiply helper with two numbers"
      },
      {
        name:     "math helper divide using variable",
        source:   '<div>{@math key="16" method="divide" operand="{y}"/}</div>',
        context:  { y : 4 },
        expected: "<div>4</div>",
        message: "testing math/divide helper with variable as operand"
      },
      {
        name:     "math helper divide  with null as key and operand value",
        source:   '<div>{@math key="{y}" method="divide" operand="{y}"/}</div>',
        context:  { y : null},
        expected: "<div>NaN</div>",
        message: "testing math/divide helper with null as key and operand value"
      },
      {
        name:     "math helper divide  with null as operand value",
        source:   '<div>{@math key="16" method="divide" operand="{y}"/}</div>',
        context:  { y : null},
        expected: "<div>NaN</div>",
        message: "testing math/divide helper with null as operand value"
      },
      {
         name:     "math helper divide  with null as undefined value",
         source:   '<div>{@math key="16" method="divide" operand="{y}"/}</div>',
         context:  { y : undefined},
         expected: "<div>NaN</div>",
         message: "testing math/divide helper with null as undefined value"
       },
      {
         name:     "math helper mod with negative 0 as operand",
         source:   '<div>{@math key="16" method="mod" operand="{y}"/}</div>',
         context:  { y : -0 },
         expected: "<div>NaN</div>",
         message: "testing math/mod helper with negative 0 as operand"
      },
      {
         name:     "math helper mod with null as key and operand",
         source:   '<div>{@math key="{y}" method="mod" operand="{y}"/}</div>',
         context:  { y : null },
         expected: "<div>NaN</div>",
         message: "testing math helper mod with null as key and operand"
      },
      {
         name:     "math helper divide using negative value for variable",
         source:   '<div>{@math key="16" method="divide" operand="{y}"/}</div>',
         context:  { y : -4 },
         expected: "<div>-4</div>",
         message: "testing math/divide helper using negative value for variable as operand"
      },
      {
           name:     "math helper divide using key as non numeric",
           source:   '<div>{@math key="doh" method="divide" operand="{y}"/}</div>',
           context:  { y : 0 },
           expected: "<div>NaN</div>",
           message: "testing math/divide helper using key as non numeric"
      },
      {
           name:     "math helper divide using 0 for variable",
           source:   '<div>{@math key="16" method="divide" operand="{y}"/}</div>',
           context:  { y : 0 },
           expected: "<div>Infinity</div>",
           message: "testing math/divide helper using 0 for variable as operand"
       },
      {
          name:     "math helper divide using negative 0 for variable",
          source:   '<div>{@math key="16" method="divide" operand="{y}"/}</div>',
          context:  { y : -0 },
          expected: "<div>Infinity</div>",
          message: "testing math/divide helper using negative 0 for variable as operand"
      },
      {
        name:     "math helper floor numbers",
        source:   '<div>{@math key="16.5" method="floor"/}</div>',
        context:  {},
        expected: "<div>16</div>",
        message: "testing math/floor helper with two numbers"
      },
      {
        name:     "math helper ceil numbers",
        source:   '<div>{@math key="16.5" method="ceil"/}</div>',
        context:  {},
        expected: "<div>17</div>",
        message: "testing math/ceil helper with two numbers"
      },
      {
        name:     "math helper round up numbers",
        source:   '<div>{@math key="16.5" method="round"/}</div>',
        context:  {},
        expected: "<div>17</div>",
        message:  "testing math/round helper rounding up with one number"
      },
      {
        name:     "math helper round down numbers",
        source:   '<div>{@math key="16.4" method="round"/}</div>',
        context:  {},
        expected: "<div>16</div>",
        message:  "testing math/round helper rounding down with one number"
      },
      {
        name:     "math helper abs numbers with missing key",
        source:   '<div>{@math key="{key}" method="abs"/}</div>',
        context:  {},
        expected: "<div>NaN</div>",
        message: "testing math/abs helper with missing key"
      },
      {
        name:     "math helper abs numbers",
        source:   '<div>{@math key="-16" method="abs"/}</div>',
        context:  {},
        expected: "<div>16</div>",
        message: "testing math/abs helper with two numbers"
      },
      {
        name:     "math helper abs numbers with null key",
        source:   '<div>{@math key="{key}" method="abs"/}</div>',
        context:  {key : null},
        expected: "<div>NaN</div>",
        message: "testing math/abs helper with null key"
      },
      {
        name:     "math helper eq filter",
        source:   '<div>{@math key="-13" method="abs"}{@eq value=13}Test is true{/eq}{/math}</div>',
        context:  {},
        expected: "<div>Test is true</div>",
        message: "testing math with body helper with abs and eq"
      },
      {
        name:     "math helper with body gt test else",
        source:   '<div>{@math key="13" method="add" operand="12"}{@gt value=123}13 + 12 > 123{:else}Math is fun{/gt}{/math}</div>',
        context:  {},
        expected: "<div>Math is fun</div>",
        message: "testing math with body else helper with add and gt"
      },
      {
        name:     "math helper with body gt default",
        source:   '<div>{@math key="13" method="add" operand="12"}{@gt value=123}13 + 12 > 123{/gt}{@default}Math is fun{/default}{/math}</div>',
        context:  {},
        expected: "<div>Math is fun</div>",
        message: "testing math with body else helper with add and gt and default"
      },
      {
        name:     "math helper with body acts like the select helper",
        source:   '<div>{@math key="1" method="add" operand="1"}math with body is truthy{:else}else is meaningless{/math}</div>',
        context:  {},
        expected: "<div>math with body is truthy</div>",
        message: "testing math with body ignores the else"
      },
      {
        name:     "math helper with body acts like the select helper",
        source:   '<div>{@math key="1" method="subtract" operand="1"}math with body is truthy even if mathout is falsy{:else}else is meaningless{/math}</div>',
        context:  {},
        expected: "<div>math with body is truthy even if mathout is falsy</div>",
        message: "testing math with body ignores the else"
      },
      {
        name:     "math helper empty body",
        source:   '<div>{@math key="1" method="add" operand="2"}{/math}</div>',
        context:  {},
        expected: "<div></div>",
        message: "testing math with an empty body will show what is inside empty"
      },
      {
        name:     "math helper simple round down with multiply, decimal key, and integer operand",
        source:   '<div>{@math key="10.05" method="multiply" operand="200" round="true"/}</div>',
        context:  {},
        expected: "<div>2010</div>",
        message:  "testing math/round down with multiply, decimal, and integer"
      },
      {
        name:     "math helper don't round down with multiply, decimal key, and integer operand",
        source:   '<div>{@math key="10.05" method="multiply" operand="200"/}</div>',
        context:  {},
        expected: "<div>2010.0000000000002</div>",
        message:  "testing math/don't round down with multiply, decimal, and integer"
      },
      {
        name:     "math helper simple round up with multiply, decimal key, and integer operand",
        source:   '<div>{@math key="0.57" method="multiply" operand="200" round="true"/}</div>',
        context:  {},
        expected: "<div>114</div>",
        message:  "testing math/round up with multiply, decimal, and integer"
      },
      {
        name:     "math helper don't round up with multiply, decimal key, and integer operand",
        source:   '<div>{@math key="0.57" method="multiply" operand="200"/}</div>',
        context:  {},
        expected: "<div>113.99999999999999</div>",
        message:  "testing math/don't round up with multiply, decimal, and integer"
      }
    ]
  },
  {
    name: "eq",
    tests: [
      {
        name:     "eq helper with no body",
        source:   "{@eq key=\"foo\" value=\"foo\"/}",
        context:  {},
        expected: "",
        message: "eq helper with no body silently fails with console log"
      },
      {
        name:     "eq helper matching string case",
        source:   "{@eq key=\"foo\" value=\"foo\"}equal{/eq}",
        context:  {},
        expected: "equal",
        message: "eq helper matching string case"
      },
      {
        name:     "eq helper non matching string case",
        source:   "{@eq key=\"foo\" value=\"bar\"}equal{:else}bar{/eq}",
        context:  {},
        expected: "bar",
        message: "eq helper non matching string case"
      },
      {
         name:     "eq helper non matching string case missing else block",
         source:   "{@eq key=\"foo\" value=\"bar\"}equal{/eq}",
         context:  {},
         expected: "",
         message: "eq helper non matching string case missing else block"
      },
      {
         name:     "eq helper equal boolean case",
         source:   "{@eq key=\"true\" value=\"true\" type=\"boolean\"}equal{/eq}",
         context:  {},
         expected: "equal",
         message: "eq helper equal boolean case"
      },
      {
         name:     "eq helper non equal/false boolean case",
         source:   "{@eq key=\"false\" value=\"true\" type=\"boolean\"}equal{/eq}",
         context:  {},
         expected: "",
         message: "eq helper non equal boolean case"
      },
      {
        name:     "eq helper without a body",
        source:   "{@eq key=\"abc\" value=\"java\"/}",
        context:  {},
        expected: "",
        message: "eq helper without a body should fail gracefully and return nothing"
      }
    ]
  },
  {
    name: "not eq",
    tests: [
      {
         name:     "not eq helper true/notequal  boolean case",
         source:   "{@ne key=\"true\" value=\"false\" type=\"boolean\"}not equal{/ne}",
         context:  {},
         expected: "not equal",
         message: "not eq helper true/notequal  boolean case"
      },
      {
         name:     "not eq helper alse/equal boolean case",
         source:   "{@ne key=\"false\" value=\"false\" type=\"boolean\"}equal{/ne}",
         context:  {},
         expected: "",
         message: "not eq helper alse/equal boolean case"
      }
    ]
  },
  {
    name: "ne",
    tests: [
      {
        name:     "ne helper with no body",
        source:   "{@ne key=\"foo\" value=\"foo\"/}",
        context:  {},
        expected: "",
        message: "ne helper with no body silently fails with console log"
      },
      {
        name:     "ne helper matching string case",
        source:   "{@ne key=\"foo\" value=\"foo\"}not equal{/ne}",
        context:  {},
        expected: "",
        message: "ne helper matching string case"
      },
      {
        name:     "ne helper non matching string case",
        source:   "{@ne key=\"foo\" value=\"bar\"}not equal{:else}bar{/ne}",
        context:  {},
        expected: "not equal",
        message: "ne helper non matching string case"
      },
      {
         name:     "ne helper non matching string case missing else block",
         source:   "{@ne key=\"foo\" value=\"bar\"}not equal{/ne}",
         context:  {},
         expected: "not equal",
         message: "ne helper non matching string case missing else block"
       },
      {
         name:     "ne helper non equal numbers case",
         source:   "{@ne key=\"3\" value=\"5\" type=\"number\"}not equal{/ne}",
         context:  {},
         expected: "not equal",
         message: "ne helper non equal numbers case"
       },
      {
         name:     "ne helper equal numbers case",
         source:   "{@ne key=\"3\" value=\"3\" type=\"number\"}not equal{/ne}",
         context:  {},
         expected: "",
         message: "ne helper equal numbers case"
       },
      {
         name:     "ne helper non equal boolean case",
         source:   "{@ne key=\"false\" value=\"true\" type=\"boolean\"}not equal{/ne}",
         context:  {},
         expected: "not equal",
         message: "ne helper non equal boolean case"
       },
      {
         name:     "ne helper equal boolean case",
         source:   "{@ne key=\"true\" value=\"true\" type=\"boolean\"}not equal{/ne}",
         context:  {},
         expected: "",
         message: "ne helper equal boolean case"
      }
    ]
  },
  {
    name: "lt",
    tests: [
      {
        name:     "lt helper with no body",
        source:   "{@lt key=\"2\" value=\"3\" type=\"number\"/}",
        context:  {},
        expected: "",
        message: "lt helper with no body silently fails with console log"
      },
      {
        name:     "lt helper defaults to type number",
        source:   "{@lt key=\"22\" value=\"33\"}22 less than 33{/lt}",
        context:  {},
        expected: "22 less than 33",
        message: "lt helper will default to type number"
      },
      {
        name:     "lt helper with a variable with explicit type number",
        source:   "{@lt key=\"{a}\" value=\"33\" type=\"number\"}22 less than 33{/lt}",
        context:  {a: 22},
        expected: "22 less than 33",
        message: "lt helper with a variable with explicit type number"
      },
      {
        name:     "lt helper with a variable defaults to type number ( type is not mandatory)",
        source:   "{@lt key=\"{a}\" value=\"33\"}22 less than 33{/lt}",
        context:  {a: 22},
        expected: "22 less than 33",
        message: "lt helper with a variable will default to type number"
      },
      {
        name:     "lt helper with a variable defaults to type number",
        source:   "{@lt key=a value=\"33\"}22 less than 33{/lt}",
        context:  {a: 22},
        expected: "22 less than 33",
        message: "lt helper with a variable will default to type number"
      },
      {
        name:     "lt helper with a variable type returned as string from tap",
        source:   "{@lt key=\"{a}\" value=\"3\"}22 less than 3, since it is string compare{/lt}",
        context:  {a: 22},
        expected: "22 less than 3, since it is string compare",
        message: "lt helper with a variable type returned as string from tap"
      },
      {
        name:     "lt helper with a variable type returned as int from tap",
        source:   "{@lt key=a value=\"3\"}22 less than 3{/lt}",
        context:  {a: 22},
        expected: "",
        message: "lt helper with a with a variable type returned as int from tap"
      },
      {
        name:     "lt helper with a variable with type string representing int",
        source:   "{@lt key=a value=\"33\"}22 less than 33{/lt}",
        context:  {a:"22"},
        expected: "22 less than 33",
        message: "lt helper with a variable with type string representing int"
      },
      {
        name:     "lt helper with a variable with type string representing float",
        source:   "{@lt key=a value=\"33\"}22 less than 33{/lt}",
        context:  {a:"22.33"},
        expected: "22 less than 33",
        message: "lt helper with a variable with type string representing float"
      }
    ]
  },
  {
    name: "gt",
    tests: [
      {
        name:     "gt helper with type string not valid case",
        source:   "{@gt key=\"22\" value=\"3\" type=\"string\"}22 greater than 3 with type string {:else}22 not greater than 3 with type string{/gt}",
        context:  {},
        expected: "22 not greater than 3 with type string",
        message: "gt helper with type string not valid case"
      },
      {
        name:     "lte helper with no body",
        source:   "{@lte key=\"2\" value=\"3\" type=\"number\"/}",
        context:  {},
        expected: "",
        message: "lte helper with no body silently fails with console log"
      },
      {
        name:     "gt helper with no body",
        source:   "{@gt key=\"5\" value=\"3\" type=\"number\"/}",
        context:  {},
        expected: "",
        message: "gt helper with no body silently fails with console log"
      },
      {
        name:     "gte helper with no body",
        source:   "{@gte key=\"5\" value=\"3\" type=\"number\"/}",
        context:  {},
        expected: "",
        message: "gte helper with no body silently fails with console log"
      }
    ]
  },
  {
    name: "select",
    tests: [
      {
        name:     "select helper with no body",
        source:   "{@select key=\"foo\"/}",
        context:  {},
        expected: "",
        message: "select helper with no body silently fails with console log"
      },
      {
        name:     "select helper with a constant string and condition eq",
        source:   ["{@select key=\"foo\"}",
                     "{@eq value=\"foo\"}foo{/eq}",
                   "{/select}"
                  ].join("\n"),
        context:  {},
        expected: "foo",
        message: "should test select helper with a constant string and condition eq"
      },
      {
        name:     "select helper with a variable string and condition eq",
        source:   ["{@select key=\"{foo}\"}",
                     "{@eq value=\"foo\"}foo{/eq}",
                   "{/select}"
                  ].join("\n"),
        context:  { "foo": "foo" },
        expected: "foo",
        message: "should test select helper with a variable string and condition eq"
      },
      {
        name:     "select helper with variable and one condition eq",
        source:   ["{@select key=foo}",
                     "{@eq value=10}foobar{/eq}",
                   "{/select}"
                  ].join("\n"),
        context:  { foo: 10 },
        expected: "foobar",
        message: "should test select helper with variable and one condition eq"
      },
      {
        name:     "select helper with string variable compared to a number and one condition eq",
        source:   ["{@select key=foo}",
                     "{@eq value=10}foobar{/eq}",
                   "{/select}"
                  ].join("\n"),
        context:  { foo: 10 },
        expected: "foobar",
        message: "should test select helper with string variable compared to a number and one condition eq"
      },
      {
        name:     "select helper with variable and one condition lt",
        source:   ["{@select key=foo}",
                     "{@lt value=20}foobar{/lt}",
                   "{/select}"
                  ].join("\n"),
        context:  { foo: 10 },
        expected: "foobar",
        message: "should test select helper with variable and one condition lt"
      },
      {
        name:     "select helper with one condition lte",
        source:   ["{@select key=foo}",
                     "{@lte value=10}foobar{/lte}",
                   "{/select}"
                  ].join("\n"),
        context:  { foo: 10 },
        expected: "foobar",
        message: "should test select helper with one condition lte"
      },
      {
        name:     "select helper with with variable and one condition lte",
        source:   ["{@select key=foo}",
                     "{@lte value=11}foobar{/lte}",
                   "{/select}"
                  ].join("\n"),
        context:  { foo: 10 },
        expected: "foobar",
        message: "should test select helper with variable and one condition lte"
      },
      {
        name:     "select helper with variable and one condition gt",
        source:   ["{@select key=foo}",
                     "{@gt value=5}foobar{/gt}",
                   "{/select}"
                  ].join("\n"),
        context:  { foo: 10 },
        expected: "foobar",
        message: "should test select helper with variable and one condition gt"
      },
      {
        name:     "select helper with variable and one condition gte",
        source:   ["{@select key=foo}",
                     "{@gte value=10}foobar{/gte}",
                   "{/select}"
                  ].join("\n"),
        context:  { foo: 10 },
        expected: "foobar",
        message: "should test select helper with variable and one condition gte"
      },
      {
        name:     "select helper with variable and one condition gte",
        source:   ["{@select key=foo}",
                     "{@gte value=5}foobar{/gte}",
                   "{/select}"
                  ].join("\n"),
        context:  { foo: 10 },
        expected: "foobar",
        message: "should test select helper with variable and one condition gte"
      },
      {
        name:     "select helper with a zero variable and one condition gte",
        source:   ["{@select key=foo}",
                     "{@gte value=0}foobar{/gte}",
                   "{/select}"
                  ].join("\n"),
        context:  { foo: 0 },
        expected: "foobar",
        message: "should test select helper with variable and one condition gte"
      },
      {
        name:     "select helper with variable of type string and eq condition",
        source:   ["{@select key=\"{foo}\"}",
                     "{@eq value=\"bar\"}foobar{/eq}",
                   "{/select}"
                  ].join("\n"),
        context:  { "foo": "bar" },
        expected: "foobar",
        message: "should test select helper with variable of type string and eq condition"
      },
      {
        name:     "select helper with two conditions",
        source:   ["{@select key=\"{foo}\"}",
                     "{@eq value=\"bar\"}foobar{/eq}",
                     "{@eq value=\"baz\"}foobaz{/eq}",
                   "{/select}"
                  ].join("\n"),
        context:  { "foo": "baz" },
        expected: "foobaz",
        message: "should test select helper works with two conditions"
      },
      {
        name:     "select helper with three conditions and default case",
        source:   ["{@select key=\"{foo}\"}",
                     "{@eq value=\"bar\"}foobar{/eq}",
                     "{@eq value=\"baz\"}foobaz{/eq}",
                     "{@eq value=\"foobar\"}foofoobar{/eq}",
                     "{@default value=\"foo\"}foofoo{/default}",
                   "{/select}"
                  ].join("\n"),
        context:  { "foo": "foo" },
        expected: "foofoo",
        message: "should test select helper with three conditions and default case"
      },
      {
        name:     "select helper with no matching conditions",
        source:   ["{@select key=\"{foo}\"}",
                     "{@eq value=\"bar\"}foobar{/eq}",
                     "{@eq value=\"baz\"}foobaz{/eq}",
                   "{/select}"
                  ].join("\n"),
        context:  { "foo": "foo" },
        expected: "",
        message: "should test select helper with no matching conditions"
      },
      {
        name:     "select helper with variable and type string with 2 conditions",
        source:   ['{@select key=test}',
                    '{@eq value="{y}"}<div>FOO</div>{/eq}',
                    '{@eq value="{x}"}<div>BAR</div>{/eq}',
                  '{/select}'].join("\n"),
        context:  { "test":"foo", "y": "foo", "x": "bar" },
        expected: "<div>FOO</div>",
        message: "should test select helper with variable and type string with 2 conditions"
      },
      {
        name:     "select helper with variable and type string in a nested object",
        source:   "{@select key=x.key}{@eq value=10}foobar{/eq}{/select}",
        context:  {"x": {"key" : 10}},
        expected: "foobar",
        message: "should test select helper with variable and type string in a nested object"
      },
      {
        name:     "select helper with variable and type string in a nested objects",
        source:   "{@select key=\"{x.b.foo}\"}{@eq value=\"a\"}foobar{/eq}{/select}",
        context:  { x : {b : { "foo" : "a"}}},
        expected: "foobar",
        message: "should test select helper with variable and type string in a nested objects"
      },

      {
        name:     "select helper with missing key in the context and hence no output",
        source:   ["{#b}{@select key=y}",
                   " {@eq value=\"{z}\"}<div>FOO</div>{/eq}",
                   " {@eq value=\"{x}\"}<div>BAR</div>{/eq}",
                   " {@default}foofoo{/default}",
                   "{/select}{/b}"].join("\n"),
        context:  { b : { z: "foo", x: "bar" } },
        expected: "",
        message: "should test select helper with missing key in the context and hence no output"
      },
      {
        name:     "select helper wih key matching the default condition",
        source:   ["{#b}{@select key=\"{x}\"}",
                   " {@eq value=\"{y}\"}<div>BAR</div>{/eq}",
                   " {@eq value=\"{z}\"}<div>BAZ</div>{/eq}",
                   " {@default value=\"foo\"}foofoo{/default}",
                   "{/select}{/b}"].join("\n"),
        context:  { b : { "x": "foo", "y": "bar", "z": "baz" } },
        expected: "foofoo",
        message: "should test select helper with key matching the default condition"
      },
      {
        name:     "select helper inside a array with .",
        source:   ["{#skills}{@select key=.}",
                   "{@eq value=\"java\"}JAVA,{/eq}",
                   "{@eq value=\"js\"}JS,{/eq}",
                   "{@default value=\"foo\"}UNKNOWN{/default}",
                   "{/select}{/skills}"].join("\n"),
        context:  { "skills" : [ "java", "js" , "unknown"] },
        expected: "JAVA,JS,UNKNOWN",
        message: "should test a select helper inside a array with ."
      },
      {
        name:     "select helper inside a array with {.}",
        source:   ["{#skills}{@select key=\"{.}\"}",
                   "{@eq value=\"java\"}JAVA,{/eq}",
                   "{@eq value=\"js\"}JS,{/eq}",
                   "{@default value=\"foo\"}UNKNOWN{/default}",
                   "{/select}{/skills}"].join("\n"),
        context:  { "skills" : [ "java", "js" , "unknown"] },
        expected: "JAVA,JS,UNKNOWN",
        message: "should test select helper inside a array with {.}"
      }
    ]
  },
  {
    name: "size",
    tests: [
      {
         name:     "size helper does not support body",
         source:   'you have {@size key=list}{body}{/size} new messages',
         context:  { list: [ 'msg1', 'msg2', 'msg3' ], "body" : "body block" },
         expected: "you have 3 new messages",
         message: "should test size helper not supporting body"
       },
      {
        name:     "size helper 3 items",
        source:   'you have {@size key=list/} new messages',
        context:  { list: [ 'msg1', 'msg2', 'msg3' ] },
        expected: "you have 3 new messages",
        message: "should test if size helper is working properly with array"
      },
      {
        name:     "size helper string",
        source:   "'{mystring}' has {@size key=mystring/} letters",
        context:  { mystring: 'hello' },
        expected: "'hello' has 5 letters",
        message: "should test if size helper is working properly with strings"
      },
      {
        name:     "size helper string (empty)",
        source:   "'{mystring}' has {@size key=mystring/} letters",
        context:  { mystring: '' },
        expected: "'' has 0 letters",
        message: "should test if size helper is working properly with strings"
      },
      {
        name:     "size helper for newline",
        source:   "{@size key=mystring/} letters",
        context:  { mystring: '\n' },
        expected: "1 letters",
        message: "should test if size is working for newline"
      },
      {
        name:     "size helper string with newline",
        source:   "{@size key=mystring/} letters",
        context:  { mystring: 'test\n' },
        expected: "5 letters",
        message: "should test if size for string with newline"
      },
      {
        name:     "size helper string with newline, tab, carriage return and bakspace",
        source:   "{@size key=mystring/} letters",
        context:  { mystring: 'test\n\t\r\b' },
        expected: "8 letters",
        message: "should test if size helper is working for string with newline, tab, carriage return and bakspace"
      },
      {
        name:     "size helper number",
        source:   'you have {@size key=mynumber/} new messages',
        context:  { mynumber: 0 },
        expected: "you have 0 new messages",
        message: "should test if size helper is working properly with numeric 0"
      },
      {
        name:     "size helper number",
        source:   'you have {@size key=mynumber/} new messages',
        context:  { mynumber: 10 },
        expected: "you have 10 new messages",
        message: "should test if size helper is working properly with numeric 10"
      },
      {
        name:     "size helper floating numeric",
        source:   'you have {@size key=mynumber/} new messages',
        context:  { mynumber: 0.4 },
        expected: "you have 0.4 new messages",
        message: "should test if size helper is working properly with floating numeric"
      },
      {
         name:     "size helper with boolean false",
         source:   'you have {@size key=myboolean/} new messages',
         context:  { myboolean: false },
         expected: "you have 0 new messages",
         message: "should test if size helper is working properly with boolean false"
      },
      {
          name:     "size helper with boolean true",
          source:   'you have {@size key=myboolean/} new messages',
          context:  { myboolean: true },
          expected: "you have 0 new messages",
          message: "should test if size helper is working properly with boolean true"
      }, 
      {
        name:     "size helper with object",
        source:   'you have {@size key=myValue/} new messages',
        context:  { myValue: { foo:'bar', baz:'bax' } },
        expected: "you have 2 new messages",
        message: "should test if size helper is working properly when the value is an object "
      },
      {
        name:     "size helper with object",
        source:   'you have {@size key=myValue/} new messages',
        context:  { myValue: {} },
        expected: "you have 0 new messages",
        message: "should test if size helper is working properly when the value is an object that is zero"
      },
      {
        name:     "size helper value not set",
        source:   'you have {@size key=myNumber/} new messages',
        context:  {},
        expected: "you have 0 new messages",
        message: "should test if size helper is working properly when the value is not present in context"
      }
    ]
  },
  {
    name: "tap",
    tests: [
      {
        name:     "tap helper: Plain text string literal",
        source:   'plain text. {@tapper value="plain text"/}',
        context:  {},
        expected: "plain text. plain text",
        message: "should test if tap helper is working properly when the value is plain text"
      },
      {
        name:     "tap helper: string literal that includes a string-valued {context variable}",
        source:   'a is {a}. {@tapper value="a is {a}"/}',
        context:  { a : "Alpha" },
        expected: "a is Alpha. a is Alpha",
        message: "should test if tap helper is working properly when the value is a text that inclues a string-valued {context variable}"
      },
      {
        name:     "tap helper: reference to string-valued context variable",
        source:   '{a}. {@tapper value=a/}',
        context:  { a : "Alpha" },
        expected: "Alpha. Alpha",
        message: "should test if tap helper is working properly when it makes referece to string-valued context variable"
      },
      {
        name:     "tap helper: string literal that includes a string-valued {context function}",
        source:   'b is {b}. {@tapper value="b is {b}"/}',
        context:  { "b" : function() { return "beta"; } },
        expected: "b is beta. b is beta",
        message: "should test if tap helper is working properly when the value is a string literal that includes a string-valued {context function}"
      },
      {
        name:     "tap helper: reference to a a string-valued {context function}",
        source:   '{b}. {@tapper value=b/}',
        context:  { "b" : function() { return "beta"; } },
        expected: "beta. beta",
        message:  "should test if tap helper is working properly when it makes reference to a a string-valued {context function}"
      },
      {
        name:     "tap helper: string literal that includes an object-valued {context variable}",
        source:   'a.foo is {a.foo}. {@tapper value="a.foo is {a.foo}"/}',
        context:  { "a" : {"foo":"bar"} },
        expected: "a.foo is bar. a.foo is bar",
        message:  "should test if tap helper is working properly when the value is a string literal that includes an object-valued {context variable}"
      },
      {
        name:     "tap helper: reference to an object-valued {context variable}",
        source:   '{a.foo}. {@tapper value=a.foo/}',
        context:  { "a" : {"foo":"bar"} },
        expected: "bar. bar",
        message:  "should test if tap helper is working properly when it makes reference to an object-valued {context variable}"
      },
      {
        name:     "tap helper: string literal that calls a function within an object-valued {context variable}",
        source:   'a.foo is {a.foo}. {@tapper value="a.foo is {a.foo}"/}',
        context:  { "a" : {"foo" : function() { return "bar"; } } },
        expected: "a.foo is bar. a.foo is bar",
        message:  "should test if tap helper is working properly when the value is string literal that calls a function within an object-valued {context variable}"
      },
      {
        name:     "tap helper: reference to a function within an object-valued {context variable}",
        source:   '{a.foo} {@tapper value=a.foo/}',
        context:  { "a" : {"foo" : function() { return "bar"; } } },
        expected: "bar bar",
        message:  "should test if tap helper is working properly when it makes reference to a function within an object-valued {context variable}"
      },
      {
        name:     "tap on a function",
        source:   '{#callTap val=foo}{/callTap}',
        context:  {
          callTap: function(chunk, context, bodies, params) {
            return chunk.write(dust.helpers.tap(params.val, chunk, context));
          },
          foo: function() {
            return 'foo';
          }
        },
        expected: "foo",
        message: "should call tap on a normal function and use it's return value to write to chunk"
      },
      {
        name:     "tap literals",
        source:   '{#callTap p1=valStr p2=valNum p3=valBool p4=valArray p5=valObj}{/callTap}',
        context:  {
          callTap: function(chunk, context, bodies, params) {
            for (var i = 1; i < 6; i ++) {
              if (params['p' + i]) {
                chunk.write(dust.helpers.tap(params['p' + i], chunk, context));
              }
            }
            return chunk;
          },
          valStr: "this is string literal",
          valNum: 54321,
          valBool: true,
          valArray: [1,2,3,4,5],
          valObj: { whoAmI: "I'm an object" }
        },
        expected: "this is string literal54321true1,2,3,4,5[object Object]",
        message: "should call tap on literals and output them as is to chunk"
      },
      {
        name:     "tap interpolated literals",
        source:   '{#callTap p1="{valStr}" p2="{valNum}" p3="{valBool}" p4="{valArray}" p5="{valObj}"}{/callTap}',
        context:  {
          callTap: function(chunk, context, bodies, params) {
            for (var i = 1; i < 6; i ++) {
              if (params['p' + i]) {
                chunk.write(dust.helpers.tap(params['p' + i], chunk, context));
              }
            }
            return chunk;
          },
          valStr: "this is string literal",
          valNum: 54321,
          valBool: true,
          valArray: [1,2,3,4,5],
          valObj: { whoAmI: "I'm an object" }
        },
        expected: "this is string literal54321true1,2,3,4,5[object Object]",
        message: "should call tap on interpolated literals and output them as is to chunk"
      },
      {
        name:     "tap on a function that is using context and chunk",
        source:   '{#callTap val=foo}{/callTap}',
        context:  {
          callTap: function(chunk, context, bodies, params) {
            return chunk.write(dust.helpers.tap(params.val, chunk, context));
          },
          foo: function(chunk, context) {
            return chunk.write(context.get('myVar'));
          },
          myVar: 'foo'
        },
        expected: "foo",
        message: "testing tap on a normal function returning chunk"
      },
      {
        name: "tap on a section param",
        source: '{#foo p1="{baz}"}{#bar}{#callTap val=p1}{/callTap}{/bar}{/foo}',
        context: {
          baz : "baz",
          foo :
            {
             bar :
              {
                callTap: function(chunk, context, bodies, params) {
                  return chunk.write(dust.helpers.tap(params.val, chunk, context));
                }
              }
            }
        },
        expected: "baz",
        message: "testing tap on a dust body function"
      }
    ]
  },
  {
    name: "contextDump",
    tests: [
      {
           name:     "contextDump simple test does not support body",
           source:   "{@contextDump}{body}{/contextDump}",
           context:  { "A" : 2, "B": 3},
           expected: "{\n  \"A\": 2,\n  \"B\": 3\n}",
           message: "contextDump simple test does not support body"
      },
      {
          name:     "contextDump simple test",
          source:   "{@contextDump/}",
          context:  { "A": 2, "B": 3},
          expected: "{\n  \"A\": 2,\n  \"B\": 3\n}",
          message: "contextDump simple test"
      },
      {
          name:     "contextDump simple test dump to console",
          source:   "{@contextDump to=\"console\"/}",
          context:  { "A": 2, "B": 3},
          expected: "",
          message: "contextDump simple test"
      },
      {
          name:     "contextDump full test",
          source:   "{@contextDump key=\"full\"/}",
          context:  { aa: { "A": 2, "B": 3} },
          expected: "{\n  \"isObject\": true,\n  \"head\": {\n    \"aa\": {\n      \"A\": 2,\n      \"B\": 3\n    }\n  }\n}",
          message: "contextDump full test"
      },
      {
          name:     "contextDump function dump test",
          source:   "{#aa param=\"{p}\"}{@contextDump key=\"full\"/}{/aa}",
          context:  { "aa": ["a"], "p" : 42},
          expected: "{\n  \"tail\": {\n    \"tail\": {\n      \"isObject\": true,\n      \"head\": {\n        \"aa\": [\n          \"a\"\n        ],\n        \"p\": 42\n      }\n    },\n    \"isObject\": true,\n    \"head\": {\n      \"param\": \"function body_2(chk, ctx) {return chk.reference(ctx._get(false, [\\\"p\\\"]), ctx, \\\"h\\\");}\",\n      \"$len\": 1,\n      \"$idx\": 0\n    }\n  },\n  \"isObject\": false,\n  \"head\": \"a\",\n  \"index\": 0,\n  \"of\": 1\n}",
          message: "contextDump function dump test"
      }
    ]
  },
  {
    name: "idx",
    tests: [
      {
        name:     "idx helper within partial included in a array",
        source:   '{#n}{@idx}{.}>>{/idx}{>hello_there name=. count="30"/}{/n}',
        context:  { n: ["Mick", "Tom", "Bob"] },
        expected: "0>>Hello Mick! You have 30 new messages.1>>Hello Tom! You have 30 new messages.2>>Hello Bob! You have 30 new messages.",
        message: "should test idx helper within partial included in a array"
      }
    ]
  },
  {
    name: "sep",
    tests: [
      {
        name:     "sep helper within partial included in a array",
        source:   '{#n}{>hello_there name=. count="30"/}{@sep} {/sep}{/n}',
        context:  { n: ["Mick", "Tom", "Bob"] },
        expected: "Hello Mick! You have 30 new messages. Hello Tom! You have 30 new messages. Hello Bob! You have 30 new messages.",
        message: "should test sep helper within partial included in a array"
      },
      {
        name:     "sep helper in a async_iterator",
        source:   "{#numbers}{#delay}{.}{/delay}{@sep}, {/sep}{/numbers}",
        context:  {
                    numbers: [3, 2, 1],
                    delay: function(chunk, context, bodies) {
                      return chunk.map(function(chunk) {
                       setTimeout(function() {
                          chunk.render(bodies.block, context).end();
                        }, Math.ceil(Math.random()*10));
                      });
                   }
                  },
        expected: "3, 2, 1",
        message: "should sep helper in a async_iterator"
      }
    ]
  }
];

if (typeof module !== "undefined" && typeof require !== "undefined") {
  module.exports = helpersTests; // We're on node.js
} else {
  this['helpersTests'] = helpersTests; // We're on the browser
}
