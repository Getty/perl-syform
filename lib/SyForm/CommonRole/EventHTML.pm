package SyForm::CommonRole::EventHTML;
# ABSTRACT: Standard role for objects with HTML event attributes

use Moo::Role;

our @events = qw(
  afterprint
  beforeprint
  beforeunload
  error
  haschange
  load
  message
  offline
  online
  pagehide
  pageshow
  popstate
  redo
  resize
  storage
  undo
  unload

  blur
  change
  contextmenu
  focus
  formchange
  forminput
  input
  invalid
  reset
  select
  submit

  keydown
  keypress
  keyup

  click
  dblclick
  drag
  dragend
  dragenter
  dragleave
  dragover
  dragstart
  drop
  mousedown
  mousemove
  mouseout
  mouseover
  mouseup
  mousewheel
  scroll

  abort
  canplay
  canplaythrough
  durationchange
  emptied
  ended
  loadeddata
  loadedmetadata
  loadstart
  pause
  play
  playing
  progress
  ratechange
  readystatechange
  seeked
  seeking
  stalled
  suspend
  timeupdate
  volumechange
  waiting
);

our @attributes = map { 'on'.$_ } @events;

for my $attribute (@attributes) {
  has $attribute => (
    is => 'ro',
    predicate => 1,
  );
}

1;
