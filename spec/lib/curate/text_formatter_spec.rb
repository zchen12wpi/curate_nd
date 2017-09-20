require 'spec_helper'

# Tests for CurateND::TextFormatter behavior
#
# The text formatting tests verify the presence of basic formatting syntax and
# appropriate behavior in different processing contexts. There is no need to
# validate the markdown spec in its entirety.
module Curate
  describe TextFormatter do
    describe '#call' do
      subject { described_class }

      it 'allows single newlines in a paragraph' do
        text = <<-eos.strip_heredoc
          If there is a single line break between blocks of text (leaving no
          empty whitespace between the text blocks) the contents of both blocks
          of text should be combined into a single paragraph tag.
          This text should NOT be in second paragraph tag.
        eos
        expect(subject.call(text: text)).to have_tag('p', count: 1)
      end

      it 'separates paragraphs with two line breaks' do
        text = <<-eos.strip_heredoc
          If there are TWO line breaks between blocks of text (leaving a single
          empty line between those text blocks) each block should be turned into
          a "p" tag.

          This text should be in second paragraph tag.
        eos
        expect(subject.call(text: text)).to have_tag('p', count: 2)
      end

      it 'makes words surrounded by single pairs italic' do
        text = <<-eos.strip_heredoc
            If text is surrounded by a pair of *asterisks* or _underscores_ it
            will be _italic_.
        eos
        expect(subject.call(text: text)).to have_tag('em', count: 3)
      end

      it 'makes words surrounded by double pairs bold' do
        text = <<-eos.strip_heredoc
            If text is surrounded by a TWO pairs of **asterisks** or
            __underscores__ it will be **bold**
        eos
        expect(subject.call(text: text)).to have_tag('strong', count: 3)
      end

      it 'makes quotes curly intelligently' do
        text = <<-eos.strip_heredoc
            Text that is "quoted" shouldn't be surrounded by double primes.
            It should use proper “curly” qotes instead.
        eos
        expect(subject.call(text: text)).to_not match(/"/)
        expect(subject.call(text: text)).to_not match(/'/)
      end
    end

    context 'title renderer' do
      it 'handles with leading numbers' do
        text = <<-eos.strip_heredoc
          5. Poursuite de la fouille de l’abri Castanet (Secteur nord, coupe Peyrony) : 2007 et 2008
        eos
        expect(subject.call(text: text, title: true)).to eq('5. Poursuite de la fouille de l’abri Castanet (Secteur nord, coupe Peyrony) : 2007 et 2008')
      end

      it 'substitutes markdown italics and bold for HTML italics and strong' do
        text = <<-eos.strip_heredoc
          5. *Poursuite* de la fouille de l’abri Castanet (__Secteur nord__, coupe Peyrony) : 2007 et _2008_
        eos
        expect(subject.call(text: text, title: true)).to eq('5. <em>Poursuite</em> de la fouille de l’abri Castanet (<strong>Secteur nord</strong>, coupe Peyrony) : 2007 et <em>2008</em>')
      end
    end

    context 'inline text' do
      it 'does not support numerical ordered lists' do
        text = <<-eos.strip_heredoc
            1. Numerical ordered lists start with a letter and a period
            2. They can have more than one item
        eos
        expect(subject.call(text: text)).to eq('')
        expect(subject.call(text: text)).to_not have_tag('li')
      end

      it 'does not support alphabetical ordered lists' do
        text = <<-eos.strip_heredoc
            a. Alphabetical ordered lists start with a letter and a period
            b. They can have more than one item
        eos
        expect(subject.call(text: text)).to_not have_tag('li')
      end

      it 'does not support unordered lists' do
        text = <<-eos.strip_heredoc
            - Unordered lists start with a dash
            - They can have more than one item
        eos
        expect(subject.call(text: text)).to_not have_tag('li')
      end
    end

    context 'block text' do
      it 'supports numerical ordered lists' do
        text = <<-eos.strip_heredoc
            1. Numerical ordered lists start with a letter and a period
            2. They can have more than one item
        eos
        expect(subject.call(text: text, block: true)).to have_tag('li', count: 2)
      end

      it 'supports alphabetical ordered lists' do
        text = <<-eos.strip_heredoc
            a. Alphabetical ordered lists start with a letter and a period
            b. They can have more than one item
        eos
        pending('alphabetical lists are not supported by Redcarpet')
        expect(subject.call(text: text, block: true)).to have_tag('li', count: 2)
      end

      it 'supports unordered lists' do
        text = <<-eos.strip_heredoc
            - Unordered lists start with a dash
            - They can have more than one item
        eos
        expect(subject.call(text: text, block: true)).to have_tag('li', count: 2)
      end
    end

    context 'link creation' do
      it 'captures a full URL' do
        text = <<-eos.strip_heredoc
          If I include a fully-qualified URL like this one: http://www.nd.edu
          there should be a link element with the "href" attribute set to the
          value of the URL literal.
        eos
        expect(subject.call(text: text)).to have_tag('a', with: { href: 'http://www.nd.edu' })
      end

      it 'captures a partial URL' do
        text = <<-eos.strip_heredoc
          If I include a URL fragment like this one: google.com there should
          be a link element with the "src" attribute set to the inferred
          value of the URL.
        eos
        pending('not supported by the Redcarpet autolink extension')
        expect(subject.call(text: text)).to have_tag('a', with: { href: 'http://google.com' })
      end
    end

    context 'HTML sanitization' do
      it 'removes script tags' do
        text = <<-eos.strip_heredoc
          A malicious user could try to inject JavaScript directly into the
          HTML via a script tag. <script>alert('Like this');</script>
        eos
        expect(subject.call(text: text)).to_not have_tag('script')
      end

      it 'removes JavaScript links' do
        text = <<-eos.strip_heredoc
          JavaScript can also be included in an anchor tag
          <a href="javascript:alert('CLICK HIJACK');">like so</a>
        eos
        expect(subject.call(text: text)).to_not have_tag('a[href]')
      end
    end

  end
end
