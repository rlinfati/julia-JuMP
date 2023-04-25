import Pkg
Pkg.add("PlutoSliderServer")
import PlutoSliderServer
PlutoSliderServer.github_action(
    "notebooks";
    Export_cache_dir = "notebooks-cache",
    Export_output_dir = "public",
    Export_offer_binder = false,
)
