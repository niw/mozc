// Copyright 2010-2011, Google Inc.
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

#ifndef MOZC_REWRITER_USAGE_REWRITER_H_
#define MOZC_REWRITER_USAGE_REWRITER_H_
#include <list>
#include <map>
#include <string>

#include "base/base.h"
#include "converter/segments.h"
#include "rewriter/rewriter_interface.h"
#include "testing/base/public/gunit_prod.h"  // for FRIEND_TEST()

namespace mozc {
struct UsageDictItem {
  const int32 id;
  const char *key;
  const char *value;
  const int32 conjugation_id;
  const char *meaning;
};

class UsageRewriter: public RewriterInterface  {
 public:
  UsageRewriter();
  virtual ~UsageRewriter();
  virtual bool Rewrite(Segments *segments) const;

 private:
  FRIEND_TEST(UsageRewriterTest, GetKanjiPrefixAndOneHiragana);

  typedef pair<string, string> StrPair;
  static string GetKanjiPrefixAndOneHiragana(const string &word);

  const UsageDictItem *LookupUnmatchedUsageHeuristically(
      const Segment::Candidate &candidate) const;
  const UsageDictItem *LookupUsage(
      const Segment::Candidate &candidate) const;

  map<StrPair, const UsageDictItem *> key_value_usageitem_map_;
};
}  // namespace mozc
#endif  // MOZC_REWRITER_USAGE_REWRITER_H_
