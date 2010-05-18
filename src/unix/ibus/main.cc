// Copyright 2010, Google Inc.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
//     * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
// copyright notice, this list of conditions and the following disclaimer
// in the documentation and/or other materials provided with the
// distribution.
//     * Neither the name of Google Inc. nor the names of its
// contributors may be used to endorse or promote products derived from
// this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#include <ibus.h>

#include "base/base.h"
#include "base/version.h"
#include "unix/ibus/mozc_engine.h"
#include "unix/ibus/path_util.h"

DEFINE_bool(ibus, false, "The engine is started by ibus-daemon");

namespace {
IBusBus *g_bus = NULL;

const char kComponentName[] = "com.google.IBus.Mozc";
const char kComponentDescription[] = "Mozc Component";
const char kLicense[] = "New BSD";
const char kAuthor[] = "Google Inc.";
const char kHomePage[] = "http://code.google.com/p/mozc/";
const char kTextDomain[] = "ibus-mozc";
const char *kEngineNames[] = { "mozc", "mozc-jp" };
const char *kEngineLayouts[] = { "us", "jp" };
const char kEngineLongName[] = "Mozc";
const char kEngineDescription[] = "Mozc Japanese input method";
const char kEngineIcon[] = "product_icon.png";
const char kEngineLanguage[] = "ja";

// Initializes ibus components and adds Mozc engine.
void InitIBusComponent(bool executed_by_ibus_daemon) {
  ibus_init();
  g_bus = ibus_bus_new();
  g_signal_connect(g_bus,
                   "disconnected",
                   G_CALLBACK(mozc::ibus::MozcEngine::Disconnected),
                   NULL);
  IBusComponent *component = ibus_component_new(
      kComponentName,
      kComponentDescription,
      mozc::Version::GetMozcVersion().c_str(),
      kLicense,
      kAuthor,
      kHomePage,
      "",
      kTextDomain);
  const string &icon_path = mozc::ibus::GetIconPath(kEngineIcon);

  COMPILE_ASSERT(
      arraysize(kEngineNames) == arraysize(kEngineLayouts), array_size_check);
  for (size_t i = 0; i < arraysize(kEngineNames); ++i) {
    ibus_component_add_engine(component,
                              ibus_engine_desc_new(kEngineNames[i],
                                                   kEngineLongName,
                                                   kEngineDescription,
                                                   kEngineLanguage,
                                                   kLicense,
                                                   kAuthor,
                                                   icon_path.c_str(),
                                                   kEngineLayouts[i]));
  }

  IBusFactory *factory = ibus_factory_new(ibus_bus_get_connection(g_bus));
  for (size_t i = 0; i < arraysize(kEngineNames); ++i) {
    ibus_factory_add_engine(factory, kEngineNames[i],
                            mozc::ibus::MozcEngine::GetType());
  }

  if (executed_by_ibus_daemon) {
    ibus_bus_request_name(g_bus, kComponentName, 0);
  } else {
    ibus_bus_register_component(g_bus, component);
  }
  g_object_unref(component);
}

}  // namespace

int main(gint argc, gchar **argv) {
  InitGoogle(argv[0], &argc, &argv, true);
  InitIBusComponent(FLAGS_ibus);
  ibus_main();
  return 0;
}
