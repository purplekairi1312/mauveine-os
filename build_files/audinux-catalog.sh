#!/bin/bash
# the music production checklist (nekozame-music): every plugin and app in Audinux
# (copr ycollet/audinux) that installs on this Fedora, with its plugin formats and
# summary, one line per plugin. runs in its own Fedora stage; writes /out/catalog.tsv
# and /out/audinux.repo
set -euo pipefail
export LC_ALL=C  # sort and join have to agree on order
dnf5 -y install dnf5-plugins
dnf5 -y copr enable ycollet/audinux
R=copr:copr.fedorainfracloud.org:ycollet:audinux
q() { dnf5 -q repoquery --repo=$R --latest-limit=1 --arch=x86_64,noarch "$@"; }

q --qf $'%{name}\t%{summary}\n' | tr ',' ';' | sort -u > /tmp/summary.tsv
q --qf '@@%{name}\n%{files}\n' | awk -f /ctx/audinux-formats.awk | sort > /tmp/formats.tsv
# leave out what isn't a plugin or app on its own: kernels, libraries, frameworks,
# split-off data, debug and devel packages, and weekly builds of things already listed
grep -v -E '^(kernel|JUCE|livecd|lib)|-(debuginfo|debugsource|devel|doc|common|data|presets|kits|examples|extra-presets)	|weekly' \
    /tmp/formats.tsv > /tmp/candidates.tsv

# drop the ones whose dependencies are broken right now
dnf5 install --assumeno --skip-broken --skip-unavailable $(cut -f1 /tmp/candidates.tsv) > /tmp/dry.txt 2>&1 || true
grep -q '^Transaction Summary' /tmp/dry.txt || { cat /tmp/dry.txt; exit 1; }
awk '/^Skipping packages/ { s = 1; next } s && /^ / { print $1; next } { s = 0 }' /tmp/dry.txt > /tmp/broken.txt
echo "broken right now: $(wc -l < /tmp/broken.txt)"

mkdir -p /out
grep -v -x -F -f /tmp/broken.txt <(cut -f1 /tmp/candidates.tsv) | sort > /tmp/ok.txt
join -t $'\t' /tmp/ok.txt /tmp/candidates.tsv | join -t $'\t' - /tmp/summary.tsv > /tmp/packages.tsv
# one line per plugin, whatever formats it's split into (clap-x, vst3-x, lv2-x...):
# name<TAB>formats<TAB>packages<TAB>summary
awk -F'\t' '
    { key = $1; sub(/^(clap|lv2|vst3|vst|ladspa|dssi)-/, "", key)
      pk[key] = pk[key] (pk[key] ? " " : "") $1
      n = split($2, f, ","); for (i = 1; i <= n; i++) if (!index("," fm[key] ",", "," f[i] ",")) fm[key] = fm[key] (fm[key] ? "," : "") f[i]
      if ($1 == key || !(key in sm)) sm[key] = $3 }
    END { for (k in pk) { x = fm[k]; sub(/(^|,)app(,|$)/, ",", x); gsub(/^,|,$/, "", x)
          if (index("," fm[k] ",", ",app,")) x = (x ? "app," x : "app")
          print k "\t" x "\t" pk[k] "\t" sm[k] } }' /tmp/packages.tsv | sort > /out/catalog.tsv
cp "/etc/yum.repos.d/_copr:copr.fedorainfracloud.org:ycollet:audinux.repo" /out/audinux.repo
echo "catalog: $(wc -l < /out/catalog.tsv) plugins and apps ($(wc -l < /tmp/packages.tsv) packages)"
[ "$(wc -l < /out/catalog.tsv)" -gt 300 ]
