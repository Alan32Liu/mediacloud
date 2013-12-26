#!/usr/bin/perl
#
# Some test strings copied from Wikipedia (CC-BY-SA, http://creativecommons.org/licenses/by-sa/3.0/).
#

use strict;
use warnings;

BEGIN
{
    use FindBin;
    use lib "$FindBin::Bin/../lib";
}

use Readonly;

use Test::NoWarnings;
use Test::More tests => 6 + 1;
use utf8;

# Test::More UTF-8 output
my $builder = Test::More->builder;
binmode $builder->output,         ":utf8";
binmode $builder->failure_output, ":utf8";
binmode $builder->todo_output,    ":utf8";

use MediaWords::Languages::ru;
use Data::Dumper;

my $test_string;
my $expected_sentences;

my $lang = MediaWords::Languages::ru->new();

#
# Simple paragraph + some non-breakable abbreviations
#
$test_string = <<'QUOTE';
Новозеландцы пять раз признавались командой года по версии IRB и являются лидером по количеству набранных
очков и единственным коллективом в международном регби, имеющим положительный баланс встреч со всеми своими
соперниками. «Олл Блэкс» удерживали первую строчку в рейтинге сборных Международного совета регби дольше,
чем все остальные команды вместе взятые. За последние сто лет новозеландцы уступали лишь шести национальным
командам (Австралия, Англия, Родезия, Уэльс, Франция и ЮАР). Также в своём активе победу над «чёрными» имеют
сборная Британских островов (англ.)русск. и сборная мира (англ.)русск., которые не являются официальными
членами IRB. Более 75 % матчей сборной с 1903 года завершались победой «Олл Блэкс» — по этому показателю
национальная команда превосходит все остальные.
QUOTE

$expected_sentences = [
'Новозеландцы пять раз признавались командой года по версии IRB и являются лидером по количеству набранных очков и единственным коллективом в международном регби, имеющим положительный баланс встреч со всеми своими соперниками.',
'«Олл Блэкс» удерживали первую строчку в рейтинге сборных Международного совета регби дольше, чем все остальные команды вместе взятые.',
'За последние сто лет новозеландцы уступали лишь шести национальным командам (Австралия, Англия, Родезия, Уэльс, Франция и ЮАР).',
'Также в своём активе победу над «чёрными» имеют сборная Британских островов (англ.)русск. и сборная мира (англ.)русск., которые не являются официальными членами IRB.',
'Более 75 % матчей сборной с 1903 года завершались победой «Олл Блэкс» — по этому показателю национальная команда превосходит все остальные.'
];

{
    is( join( '||', @{ $lang->get_sentences( $test_string ) } ), join( '||', @{ $expected_sentences } ), "sentence_split" );
}

#
# Abbreviation ("в т. ч.")
#
$test_string = <<'QUOTE';
Топоры, в т. ч. транше и шлифованные. Дания.
QUOTE

$expected_sentences = [ 'Топоры, в т. ч. транше и шлифованные.', 'Дания.' ];

{
    is( join( '||', @{ $lang->get_sentences( $test_string ) } ), join( '||', @{ $expected_sentences } ), "sentence_split" );
}

#
# Abbreviation ("род.")
#
$test_string = <<'QUOTE';
Влади́мир Влади́мирович Пу́тин (род. 7 октября 1952, Ленинград) — российский государственный
и политический деятель; действующий (четвёртый) президент Российской Федерации с 7 мая 2012
года. Председатель Совета министров Союзного государства (с 2008 года). Второй президент
Российской Федерации с 7 мая 2000 года по 7 мая 2008 года (после отставки президента Бориса
Ельцина исполнял его обязанности с 31 декабря 1999 по 7 мая 2000 года).
QUOTE

$expected_sentences = [
'Влади́мир Влади́мирович Пу́тин (род. 7 октября 1952, Ленинград) — российский государственный и политический деятель; действующий (четвёртый) президент Российской Федерации с 7 мая 2012 года.',
    'Председатель Совета министров Союзного государства (с 2008 года).',
'Второй президент Российской Федерации с 7 мая 2000 года по 7 мая 2008 года (после отставки президента Бориса Ельцина исполнял его обязанности с 31 декабря 1999 по 7 мая 2000 года).'
];

{
    is( join( '||', @{ $lang->get_sentences( $test_string ) } ), join( '||', @{ $expected_sentences } ), "sentence_split" );
}

#
# Name abbreviations
#
$test_string = <<'QUOTE';
Впоследствии многие из тех, кто вместе с В. Путиным работал в мэрии Санкт-Петербурга (И. И.
Сечин, Д. А. Медведев, В. А. Зубков, А. Л. Кудрин, А. Б. Миллер, Г. О. Греф, Д. Н. Козак,
В. П. Иванов, С. Е. Нарышкин, В. Л. Мутко и др.) в 2000-е годы заняли ответственные посты
в правительстве России, администрации президента России и руководстве госкомпаний.
QUOTE

$expected_sentences = [
'Впоследствии многие из тех, кто вместе с В. Путиным работал в мэрии Санкт-Петербурга (И. И. Сечин, Д. А. Медведев, В. А. Зубков, А. Л. Кудрин, А. Б. Миллер, Г. О. Греф, Д. Н. Козак, В. П. Иванов, С. Е. Нарышкин, В. Л. Мутко и др.) в 2000-е годы заняли ответственные посты в правительстве России, администрации президента России и руководстве госкомпаний.'
];

{
    is( join( '||', @{ $lang->get_sentences( $test_string ) } ), join( '||', @{ $expected_sentences } ), "sentence_split" );
}

#
# Date ("19.04.1953")
#
$test_string = <<'QUOTE';
Род Моргенстейн (англ. Rod Morgenstein, род. 19.04.1953, Нью-Йорк) — американский барабанщик,
педагог. Он известен по работе с хеви-метал группой конца 80-х Winger и джаз-фьюжн группой
Dixie Dregs. Участвовал в сессионной работе с группами Fiona, Platypus и The Jelly Jam. В
настоящее время он профессор музыкального колледжа Беркли, преподаёт ударные инструменты.
QUOTE

$expected_sentences = [
'Род Моргенстейн (англ. Rod Morgenstein, род. 19.04.1953, Нью-Йорк) — американский барабанщик, педагог.',
'Он известен по работе с хеви-метал группой конца 80-х Winger и джаз-фьюжн группой Dixie Dregs.',
    'Участвовал в сессионной работе с группами Fiona, Platypus и The Jelly Jam.',
'В настоящее время он профессор музыкального колледжа Беркли, преподаёт ударные инструменты.'
];

{
    is( join( '||', @{ $lang->get_sentences( $test_string ) } ), join( '||', @{ $expected_sentences } ), "sentence_split" );
}

#
# Word tokenizer
#
$test_string = <<'QUOTE';
Род Моргенстейн (англ. Rod Morgenstein, род. 19.04.1953, Нью-Йорк) —
американский барабанщик, педагог. Он известен по работе с хеви-метал группой
конца 80-х Winger и джаз-фьюжн группой Dixie Dregs.
QUOTE

my $expected_words = [
    qw/
      род моргенстейн англ rod morgenstein род 19 04 1953 нью йорк американский
      барабанщик педагог он известен по работе с хеви метал группой конца 80 х winger
      и джаз фьюжн группой dixie dregs/
];

{
    is( join( '||', @{ $lang->tokenize( $test_string ) } ), join( '||', @{ $expected_words } ), "tokenize" );
}
