local Input = {

	["left_button"] = "ability_primary",
	["ability_primary"] = "left button",

	["right_button"] = "ability_secondary",
	["ability_secondary"] = "right button",

	["0"] = "ability_extra_0",
	["ability_extra_0"] = "0",

	["1"] = "ability_extra_1",
	["ability_extra_1"] = "1",

	["2"] = "ability_extra_2",
	["ability_extra_2"] = "2",

	["3"] = "ability_extra_3",
	["ability_extra_3"] = "3",

	["4"] = "ability_extra_4",
	["ability_extra_4"] = "4",

	["5"] = "ability_extra_5",
	["ability_extra_5"] = "5",

	["6"] = "ability_extra_6",
	["ability_extra_6"] = "6",

	["7"] = "ability_extra_7",
	["ability_extra_7"] = "7",

	["8"] = "ability_extra_8",
	["ability_extra_8"] = "8",

	["9"] = "ability_extra_9",
	["ability_extra_9"] = "9",

	["left_ctrl"] = "ability_extra_10",
	["ability_extra_10"] = "left ctrl",

	["right_ctrl"] = "ability_extra_11",
	["ability_extra_11"] = "right ctrl",

	["left_shift"] = "ability_extra_12",
	["ability_extra_12"] = "left shift",

	["right_shift"] = "ability_extra_13",
	["ability_extra_13"] = "right shift",

	["left_alt"] = "ability_extra_14",
	["ability_extra_14"] = "left alt",

	["right_alt"] = "ability_extra_15",
	["ability_extra_15"] = "right alt",

	["enter"] = "ability_extra_16",
	["ability_extra_16"] = "enter",

	["space"] = "ability_extra_17",
	["ability_extra_17"] = "space",

	["caps_lock"] = "ability_extra_18",
	["ability_extra_18"] = "caps lock",

	["tab"] = "ability_extra_19",
	["ability_extra_19"] = "tab",

	["q"] = "ability_extra_20",
	["ability_extra_20"] = "q",

	["w"] = "ability_extra_21",
	["ability_extra_21"] = "w",

	["e"] = "ability_extra_22",
	["ability_extra_22"] = "e",

	["r"] = "ability_extra_23",
	["ability_extra_23"] = "r",

	["t"] = "ability_extra_24",
	["ability_extra_24"] = "t",

	["y"] = "ability_extra_25",
	["ability_extra_25"] = "y",

	["u"] = "ability_extra_26",
	["ability_extra_26"] = "u",

	["i"] = "ability_extra_27",
	["ability_extra_27"] = "i",

	["o"] = "ability_extra_28",
	["ability_extra_28"] = "o",

	["p"] = "ability_extra_29",
	["ability_extra_29"] = "p",

	["a"] = "ability_extra_30",
	["ability_extra_30"] = "a",

	["s"] = "ability_extra_31",
	["ability_extra_31"] = "s",

	["d"] = "ability_extra_32",
	["ability_extra_32"] = "d",

	["f"] = "ability_extra_33",
	["ability_extra_33"] = "f",

	["g"] = "ability_extra_34",
	["ability_extra_34"] = "g",

	["h"] = "ability_extra_35",
	["ability_extra_35"] = "h",

	["j"] = "ability_extra_36",
	["ability_extra_36"] = "j",

	["k"] = "ability_extra_37",
	["ability_extra_37"] = "k",

	["l"] = "ability_extra_38",
	["ability_extra_38"] = "l",

	["z"] = "ability_extra_39",
	["ability_extra_39"] = "z",

	["x"] = "ability_extra_40",
	["ability_extra_40"] = "x",

	["c"] = "ability_extra_41",
	["ability_extra_41"] = "c",

	["v"] = "ability_extra_42",
	["ability_extra_42"] = "v",

	["b"] = "ability_extra_43",
	["ability_extra_43"] = "b",

	["n"] = "ability_extra_44",
	["ability_extra_44"] = "n",

	["m"] = "ability_extra_45",
	["ability_extra_45"] = "m",

	["up"] = "ability_extra_46",
	["ability_extra_46"] = "up",

	["down"] = "ability_extra_47",
	["ability_extra_47"] = "down",

	["left"] = "ability_extra_48",
	["ability_extra_48"] = "left",

	["right"] = "ability_extra_49",
	["ability_extra_49"] = "right",

	["f1"] = "ability_extra_50",
	["ability_extra_50"] = "f1",

	["f2"] = "ability_extra_51",
	["ability_extra_51"] = "f2",

	["f3"] = "ability_extra_52",
	["ability_extra_52"] = "f3",

	["f4"] = "ability_extra_53",
	["ability_extra_53"] = "f4",

	["f5"] = "ability_extra_54",
	["ability_extra_54"] = "f5",

	["f6"] = "ability_extra_55",
	["ability_extra_55"] = "f6",

	["f7"] = "ability_extra_56",
	["ability_extra_56"] = "f7",

	["f8"] = "ability_extra_57",
	["ability_extra_57"] = "f8",

	["f9"] = "ability_extra_58",
	["ability_extra_58"] = "f9",

	["f10"] = "ability_extra_59",
	["ability_extra_59"] = "f10",

	["f11"] = "ability_extra_60",
	["ability_extra_60"] = "f11",

	["f12"] = "ability_extra_61",
	["ability_extra_61"] = "f12",

	["ins"] = "ability_extra_62",
	["ability_extra_62"] = "ins",

	["home"] = "ability_extra_63",
	["ability_extra_63"] = "home",

	["page_up"] = "ability_extra_64",
	["ability_extra_64"] = "page up",

	["page_down"] = "ability_extra_65",
	["ability_extra_65"] = "page down",

	["del"] = "ability_extra_66",
	["ability_extra_66"] = "del",

	["end"] = "ability_extra_67",
	["ability_extra_67"] = "end",

}

return Input

--[[
var t = document.querySelector(".md-typeset__table")
var r = t.querySelectorAll("tr")

var str = ""

for(var i = 1; i < r.length; i ++){
	var cells = r[i].querySelectorAll("td")
	
	str += "\t[\"" + cells[0].textContent.replace(/\s+/g, "_").toLowerCase() + "\"] = ";
	str += "\"" + cells[1].textContent.toLowerCase() + "\",\n"
	
	str += "\t[\"" + cells[1].textContent.replace(/\s+/g, "_").toLowerCase() + "\"] = ";
	str += "\"" + cells[0].textContent.toLowerCase() + "\","
	
	str += "\n\n"
}

console.log(str)
]]