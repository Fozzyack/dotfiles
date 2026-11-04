local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    s({ trig = "pydataclass", dscr = "Dataclass with a per-instance list default (Python 3.9+)" }, fmt([=[
from dataclasses import dataclass, field

@dataclass
class <>:
    <>: <>
    <>: list[str] = field(default_factory=list)
<>
]=], { i(1, "Record"), i(2, "name"), i(3, "str"), i(4, "tags"), i(0) }, { delimiters = "<>" })),

    s({ trig = "pyargparse", dscr = "Standard-library command-line argument parser" }, fmt([=[
import argparse

parser = argparse.ArgumentParser(description="<>")
parser.add_argument("<>", help="<>")
args = parser.parse_args()
<>
]=], { i(1, "Describe the command"), i(2, "path"), i(3, "Input path"), i(0) }, { delimiters = "<>" })),

    s({ trig = "pyrun", dscr = "Checked subprocess with captured text output" }, fmt([=[
import subprocess

<> = subprocess.run(
    [<>],
    check=True,
    capture_output=True,
    text=True,
)
<>
]=], { i(1, "result"), i(2, '"python3", "--version"'), i(0) }, { delimiters = "<>" })),
}
