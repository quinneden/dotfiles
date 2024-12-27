# this file define which languages should have
# four tabs indentation
{ lib }:
lib.fold
  (
    lang: acc:
    acc
    // {
      "[${lang.name}]" =
        (
          if lang.formatter != "undefined" then
            {
              "editor.defaultFormatter" = lang.formatter;
            }
          else
            { }
        )
        // {
          "editor.tabSize" = 4;
        };
    }
  )
  { }
  (
    let
      mk = name: formatter: { inherit name formatter; };
    in
    [
      (mk "rust" "undefined")
      (mk "python" "ms-python.black-formatter")
      (mk "java" "undefined")
      (mk "zig" "undefined")
    ]
  )
