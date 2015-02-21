require "spec_helper"

describe AOJ::Env do
  describe 'parse_proxy_info' do
    context 'when only host given' do
      let(:env) { create_env("HTTP_PROXY" => "http://hoge.co.jp/") }

      it { expect(env.parse_proxy_info).to eq(host: "hoge.co.jp") }
    end

    context 'when host and port given' do
      let(:env) { create_env("HTTP_PROXY" => "http://hoge.co.jp:8080/") }

      it {
        expect(env.parse_proxy_info).to eq(
          host: "hoge.co.jp",
          port: 8080
        )
      }
    end

    context 'when user, pass, host given' do
      let(:env) { create_env("HTTP_PROXY" => "http://nao:secret@hoge.co.jp/") }

      it {
        expect(env.parse_proxy_info).to eq(
          host: "hoge.co.jp",
          user: "nao",
          pass: "secret"
        )
      }
    end

    context 'when user, pass, host and port given' do
      let(:env) { create_env("HTTP_PROXY" => "http://nao:secret@hoge.co.jp:8080/") }

      it {
        expect(env.parse_proxy_info).to eq(
          host: "hoge.co.jp",
          port: 8080,
          user: "nao",
          pass: "secret"
        )
      }
    end

    context 'when no proxy info given' do
      let(:env) { AOJ::Env.new({}) }

      it { expect(env.parse_proxy_info).to eq({}) }
    end
  end

  describe 'proxy_specified?' do
    context 'when proxy info given' do
      let(:env) { create_env("HTTP_PROXY" => "http://hoge.co.jp") }

      it { expect(env.proxy_specified?).to be_truthy }
    end

    context 'when no proxy info given' do
      let(:env) { AOJ::Env.new({}) }

      it { expect(env.proxy_specified?).to be_falsy }
    end
  end

  def create_env(hash)
    hash.each { |key, value| value.freeze }
    AOJ::Env.new(hash)
  end
end
