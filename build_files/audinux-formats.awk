# reads repoquery output ("@@name" lines, each followed by that package's files) and
# prints name<TAB>plugin formats, or "app" for a program with no plugins in it
/^@@/ { n = substr($0, 3); next }
n == "" { next }
/\/lib(64)?\/lv2\//    { f[n, "lv2"] = 1 }
/\/lib(64)?\/vst3\//   { f[n, "vst3"] = 1 }
/\/lib(64)?\/vst\//    { f[n, "vst2"] = 1 }
/\/lib(64)?\/clap\//   { f[n, "clap"] = 1 }
/\/lib(64)?\/ladspa\// { f[n, "ladspa"] = 1 }
/^\/usr\/share\/applications\/.*\.desktop$/ { a[n] = 1 }
{ seen[n] = 1 }
END {
    for (n in seen) {
        s = ""
        split("clap vst3 lv2 vst2 ladspa", k, " ")
        for (i = 1; i <= 5; i++) if ((n, k[i]) in f) s = s (s ? "," : "") k[i]
        if (s == "" && (n in a)) s = "app"
        if (s != "") print n "\t" s
    }
}
