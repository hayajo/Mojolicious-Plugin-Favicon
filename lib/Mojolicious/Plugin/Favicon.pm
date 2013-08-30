package Mojolicious::Plugin::Favicon;

use strict;
use 5.008_005;
our $VERSION = '0.01';

use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ( $self, $app, $conf ) = @_;

    $app->hook( after_render => sub {
        my ($c, $output, $format) = @_;

        return
            unless ( $format eq 'html' && $conf && (my $favicon = $conf->{ $app->mode } ) );

        my $dom = Mojo::DOM->new($$output);

        # remove favicon tags
        my $favicon_link = $dom->find('link[rel*="icon"]');
        $favicon_link->each(sub{ $_[0]->remove }) if ($favicon_link);

        my $head = $dom->at('head');

        # append head tag if not exist
        if ( !$head ) {
            my $body = $dom->at('body') or return;
            $body->prepend('<head></head>');
            $head = $dom->at('head');
        }

        my $tag_str = sprintf('<link rel="shortcut icon" href="%s">', $favicon);

        if ($head->children->size) {
            $dom->at('head')->children->first->prepend($tag_str);
        }
        else {
            # FIXME
            $dom->at('head')->replace("<head>${tag_str}</head>");
        }

        $$output = "$dom";
    } );
}

1;
__END__

=encoding utf-8

=head1 NAME

Mojolicious::Plugin::Favicon - change favicon by Mojolicious@mode

=head1 SYNOPSIS

  plugin 'Mojolicious::Plugin::Favicon' => { development => '/favicon.dev.ico' };

=head1 DESCRIPTION

Mojolicious::Plugin::Favicon is

=head1 AUTHOR

hayajo E<lt>hayajo@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2013- hayajo

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
