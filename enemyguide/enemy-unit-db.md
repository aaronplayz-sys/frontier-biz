---
layout: default
title: Enemy Unit Database
parent: 💀 Enemy Guide
nav_order: 22
custom_class: battlefield-theme
---

# Frontier Defense: Enemy Unit Database

{% include unit_filters.html %}

{% include unit_card.html 
   name="Nuke Titan" 
   faction="IMC Heavy Armor" 
   threat_level="critical" 
   waves="3, 4, 5"
   description="Slow-moving strider/atlas variant carrying a volatile nuclear core." 
   weakness="Rear Critical Engine Exhaust & Tether Traps" 
   counter="Northstar Tether Traps + Nuke Eject or Scorch Thermal Shield" %}

{% include unit_card.html 
   name="Arc Titan" 
   faction="IMC Shock Infantry" 
   threat_level="high" 
   waves="2, 3, 4, 5"
   description="Aggressive Ronin variant equipped with a constant localized electrical field." 
   weakness="Sustained Ranged Fire (Keep Distance)" 
   counter="Monarch Energy Siphon or Long Range Power Shot" %}

{% include unit_card.html 
   name="Stalker Squad" 
   faction="Vinson Dynamics Automated" 
   threat_level="low" 
   waves="1, 2"
   description="Heavy robotic infantry that continues crawling forward even after losing legs." 
   weakness="Backpack Battery Pack" 
   counter="Electric Smoke & Anti-Personnel Ordnance" %}