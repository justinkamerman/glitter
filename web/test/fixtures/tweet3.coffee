(window.FIXTURES ||= {}).tweet3 =
  tweet:
    { id: 3, text: "distance from origin test", author: 1 }
  nodes: [
    { id: 1, screen_name: "originator" }            #0
    { id: 2, screen_name: "d1a" }                   #1
    { id: 3, screen_name: "d1b" }                   #2
    { id: 4, screen_name: "d1a_d2a" }               #3
    { id: 5, screen_name: "d1a_d2b" }               #4
    { id: 6, screen_name: "d1a_d2a_d3a" }           #5
    { id: 7, screen_name: "no_link_to_originator" } #6
    { id: 8, screen_name: "child_of_no_link_to_originator" }
  ]
  links: [
    { source: 0, target: 1 }
    { source: 0, target: 2 }
    { source: 1, target: 3 }
    { source: 1, target: 4 }
    { source: 3, target: 5 }
    { source: 6, target: 7 }
  ]