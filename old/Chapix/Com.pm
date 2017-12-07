package Chapix::Com;

use strict;
use CGI qw/:standard/;
use CGI::Carp qw(fatalsToBrowser);
use DBI;
use Apache::Session::MySQL;
use Template;
#use Image::Thumbnail;
#use Image::Size;

use Chapix::Conf;

BEGIN {
    use Exporter();
    use vars qw( @ISA @EXPORT @EXPORT_OK );
    @ISA = qw( Exporter );
    @EXPORT = qw(
        $dbh
        %sess
        $cookie
        &msg_add
        &msg_print
        &msg_get
        &upload_file
        &upload_usr_file
        &http_redirect
        &header_out
        &get_url
        $language
        $_REQUEST
        $_HEADERS
        $Template
        &format_short_name
        &format_name
        &get_display_key
        );
}

use vars @EXPORT;

#################################################################################
# App Init
#################################################################################

# CGI params
my $Q = CGI->new;

foreach my $key (keys %{$Q->Vars()}){
    $_REQUEST->{$key} = $Q->param($key);
}

my %headers = map { $_ => $Q->http($_) } $Q->http();
for my $header ( keys %headers ) {
    $_HEADERS->{$header} = $headers{$header};
}

my $URL = $ENV{SCRIPT_URL};
my $BaseURL = $conf->{ENV}->{BaseURL};

# DataBase
$dbh = DBI->connect( $conf->{DBI}->{conection}, $conf->{DBI}->{user_name}, $conf->{DBI}->{password},{RaiseError => 1,AutoCommit=>1}) or die "Can't Connect to database.";
$dbh->do("SET CHARACTER SET 'utf8'");
$dbh->do("SET time_zone=?",{},$conf->{DBI}->{time_zone});
#$dbh->do("SET lc_time_names = ?",{},$conf->{DBI}->{lc_time_names});

# Session
my $session_id;
if (defined $ENV{'HTTP_COOKIE'}){
    my %cookies = map {$_ =~ /\s*(.+)=(.+)/g} ( split( /;/, $ENV{'HTTP_COOKIE'} ) );
    $session_id = $cookies{$conf->{SESSION}->{name}};
}

eval {
    tie %sess, 'Apache::Session::MySQL', $session_id, {
	Handle     => $dbh,
	LockHandle => $dbh,
	TableName  => $conf->{Xaa}->{DB} . '.sessions',
    };
};

if ($@) {
    eval {
	$session_id = '';
	tie %sess, 'Apache::Session::MySQL' , $session_id,{
	    Handle     => $dbh,
	    LockHandle => $dbh,
	    TableName  => $conf->{Xaa}->{DB} . '.sessions',
	};
    };
    die "Can't create session data $@" if($@);
}

defined $sess{account_id}    or $sess{account_id} = '';
defined $sess{account_name}  or $sess{account_name} = '';
defined $sess{account_email} or $sess{account_email} = '';
$sess{account_language} = "es_MX"; 
#or $sess{account_language} = detect_browser_language('en_US');

$cookie = cookie(-name    => $conf->{SESSION}->{name},
		 -value   => $sess{_session_id},
		 -path    => $conf->{SESSION}->{path},
		 -expires => $conf->{SESSION}->{life},
    );
#Session END

$URL =~ s/^$BaseURL//g;
($_REQUEST->{Controller}, $_REQUEST->{View}, $_REQUEST->{Object}) = split(/\//, $URL);
$_REQUEST->{Controller} =~ s/\W//g;
$_REQUEST->{View}    =~ s/\W//g;
$_REQUEST->{Object}    =~ s/\W//g;

$_REQUEST->{Controller} = '' if(!$_REQUEST->{Controller});
$_REQUEST->{View}       = '' if(!$_REQUEST->{View});
$_REQUEST->{Object}     = '' if(!$_REQUEST->{Object});

if(length($_REQUEST->{Controller}) == 3 ){
    $_REQUEST->{StaticPageLanguage} =  lc($_REQUEST->{Controller});
    $_REQUEST->{StaticPage}         =  $_REQUEST->{View};

    $_REQUEST->{Controller}    = '';
    $_REQUEST->{View}          = '';
    $_REQUEST->{Object}        = '';
}


if(!$sess{account_id} && !$_REQUEST->{Controller}){
    $_REQUEST->{Controller} = "Accounts";
    $_REQUEST->{View} = "Login";
}elsif(!$_REQUEST->{Controller}){
    $_REQUEST->{Controller} = "Accounts";
    $_REQUEST->{View} = "Login";
}elsif($sess{account_id} && $_REQUEST->{Controller} eq 'FOMAC'){
	$_REQUEST->{Controller} = "Form";
}


# Load basic config
conf_load('Website');
conf_load('Domain');
conf_load('Template');

# Default template
$Template = Template->new(
    INCLUDE_PATH => 'templates/'.$conf->{Template}->{TemplateID}.'/',
);

#################################################################################
# Common Functions
#################################################################################

# Print the httpheader including cookie and characterset
sub header_out {
  return header(-cookie=>$cookie,-charset=>"utf-8",-Expires=>-1);
}

sub msg_add {
  my $type = shift;
  my $text = shift;
  $dbh->do("INSERT IGNORE INTO $conf->{Xaa}->{DB}.sessions_msg (session_id, type, msg) values(?,?,?)",{},$sess{_session_id},$type, $text);
}

sub msg_print {
  my $HTML = "";
  my $msgs = $dbh->selectall_arrayref("SELECT m.type, m.msg FROM $conf->{Xaa}->{DB}.sessions_msg m WHERE m.session_id=?",{},$sess{_session_id});
  foreach my $msg (@$msgs){
    my $class = '';
    $HTML .= '<div class="card-panel msg msg-'.$msg->[0].'">' . $msg->[1] . '</div>';
  }
  $dbh->do("DELETE FROM $conf->{Xaa}->{DB}.sessions_msg WHERE session_id=?",{},$sess{_session_id}) if($msgs->[0]);
  return $HTML;
}

sub msg_get {
    my $msg_str = "";
    my $msgs = $dbh->selectall_arrayref("SELECT m.type, m.msg FROM $conf->{Xaa}->{DB}.sessions_msg m WHERE m.session_id=?",{},$sess{_session_id});
    foreach my $msg (@$msgs){
        $msg_str .= $msg->[1];
    }
    $dbh->do("DELETE FROM $conf->{Xaa}->{DB}.sessions_msg WHERE session_id=?",{},$sess{_session_id}) if($msgs->[0]);
    return $msg_str;
}

# Web browser redirect
sub http_redirect {
  my $dest = shift;
  untie %sess;
  $dbh->disconnect();
  print redirect($dest);
  exit 0;
}

# Save session data and disconect from DB
sub app_end {
  untie %sess;
  $dbh->disconnect();
  exit 0;
}

sub set_path_route {
  my @items = @_;
  my $route = '';
  foreach my $item(@items){
    my $name = $item->[0];
    $name = CGI::a({-href=>$item->[1]},$name) if($item->[1]);
    $route .= ' <li>'.$name.'<span class="divider"><i class="icon-angle-right"></i></span></li> ';
  }
  $conf->{Page}->{Path} = '<ul class="path"><li><a href="/">Home</a><span class="divider"><i class="glyphicon glyphicon-menu-right"></i></span></li>' . $route.'</ul>';
}

sub conf_load {
  my $module = shift;
  my $vars = $dbh->selectall_arrayref("SELECT c.module, c.name, c.value FROM conf c WHERE c.module=? AND value IS NOT NULL",{Slice=>{}},$module);
  foreach my $var (@$vars){
    defined $conf->{$var->{module}} or $conf->{$var->{module}} = {};
    $conf->{$var->{module}}->{$var->{name}} = $var->{value} || '';
  }
}

sub selectbox_data {
  my %data = (
  values => [],
  labels => {},
  );
  my $select = shift || "";
  my $params = shift;
  my $sth = $dbh->prepare($select);
  if($params){
    if(ref($params) eq 'ARRAY'){
      $sth->execute(@$params);
    }else{
      $sth->execute($params);
    }
  }else{
    $sth->execute();
  }
  while ( my $rec = $sth->fetchrow_arrayref() ) {
    push(@{$data{values}},$rec->[0]);
    $data{labels}{$rec->[0]} = $rec->[1];
  }
  return %data;
}

sub admin_log {
  my $module = shift;
  my $action = shift;
  my $admin_id = shift || $sess{admin_id};

  $dbh->do("INSERT INTO admins_log (admin_id, date, module, comments, ip_address) VALUES(?,NOW(),?,?,?)",{},
  $admin_id, $module, $action, $ENV{REMOTE_ADDR});
}

sub set_toolbar {
  my @actions = @_;
  my $LeftHTML = '';
  my $RightHTML = '';
  my $HTML = '';

  foreach my $action (@actions){
    my $btn = '';
    my $alt = '';
    my ($script, $label, $side, $icon, $class, $type) = @$action;
    $class = 'btn btn-default btn-sm' if(!$class);
    if($script eq 'index.pl' or ($label eq '')){
      $alt = 'Level up';
      $icon  = 'level-up';
      $side  = 'right';
    }
    $btn .= ' <a href="'.$script.'" class="'.$class.'" alt="'.$alt.'" title="'.$alt.'" >';
    if($icon){
      $btn .= '<i class="glyphicon glyphicon-'.$icon.'"></i> ';
    }
    $btn .= $label.'</a>';
    if($side eq 'right'){
      $RightHTML .= $btn;
    }else{
      $LeftHTML .= $btn;
    }
  }

  $HTML .= $LeftHTML;
  $HTML .= '<div class="pull-right">' . $RightHTML .'</div>' if($RightHTML);

  $conf->{Page}->{Toolbar} = $HTML;
}

sub upload_file {
  my $cgi_param = shift || "";
  my $dir = shift || "";
  my $filename = $_REQUEST->{$cgi_param};
  my $mime = '';
  my $save_as = shift || "";

  if(!(-e "data/$dir/")){
      mkdir ("data/$dir/");
  }

  if($filename){

    my $type = uploadInfo($filename)->{'Content-Type'};
    my ($name, $extension) = split(/\./, $filename);

    my $file = $save_as || clean_str($name);
    $file = (time() . int(rand(9999999))) if (!$file);
    
    if($type eq "image/jpeg" or $type eq "image/x-jpeg"  or $type eq "image/pjpeg"){
      $file .= ".jpg";
      $mime = 'img';
    }elsif($type eq "image/png" or $type eq "image/x-png"){
      $file .= ".png";
      $mime = 'img';
    }elsif($type eq "image/gif" or $type eq "image/x-gif"){
      $file .= ".gif";
      $mime = 'img';
    }elsif($filename =~ /\.pdf$/i){
      $file .= ".pdf";
      $mime = 'pdf';
    }elsif($filename =~ /\.doc$/i){
      $file .= ".doc";
      $mime = 'doc';
    }elsif($filename =~ /\.xls$/i){
      $file .= ".xls";
      $mime = 'xls';
    }elsif($filename =~ /\.csv$/i){
      $file .= ".csv";
      $mime = 'csv';
    }elsif($filename =~ /\.ppt$/i){
      $file .= ".ppt";
      $mime = 'ppt';
    }elsif($filename =~ /\.docx$/i){
      $file .= ".docx";
      $mime = 'docx';
    }elsif($filename =~ /\.xlsx$/i){
      $file .= ".xlsx";
      $mime = 'xlsx';
    }elsif($filename =~ /\.pptx$/i){
      $file .= ".pptx";
      $mime = 'pptx';
    }elsif($filename =~ /\.swf$/i){
      $file .= ".swf";
      $mime = 'swf';
    }elsif($filename =~ /\.mp4$/i){
      $file .= ".mp4";
      $mime = 'mp4';
    }elsif($filename =~ /\.zip$/i){
      $file .= ".zip";
      $mime = 'zip';
    }elsif($filename =~ /\.txt$/i){
      $file .= ".txt";
      $mime = 'txt';
    }else{
      msg_add("danger","Solo imagenes y archivos pdf y zip son soportados.");
      return "";
    }
    if($file){

      if (-e "data/$dir/$file") {
        foreach my $it (1 .. 1000000) {
          $file = $name.'_'.$it.'.'.$extension;
          if(!(-e "data/$dir/$file")){
            last;
          }
        }
      }
      
      open (OUTFILE,">data/$dir/" . $file) or die "$!";
      binmode(OUTFILE);
      my $bytesread;
      my $buffer;
      while ($bytesread=read($filename,$buffer,1024)) {
        print OUTFILE $buffer;
      }
      close(OUTFILE);
      return $file;
    }
  }
  return "";
}

sub thumbnail {
  my $new_size = shift;
  my $source   = shift;
  my $target   = shift;
  my $file     = shift;
  my ($new_width, $new_height) = split(/x/,$new_size);

  #existe la fuente
  if(! (-e "data/$source/$file")){
    msg_add('error','No se pudo crear imagen chica, no existe la fuente');
    return;
  }

  #Target directory
  if(!(-e "data/$target/")){
    mkdir("data/$target/") or die 'No se puede crear el directorio de datos.';
  }
  my ($width, $height) = imgsize("data/$source/".$file);

  if($file =~ /\.gif/i){
    copy("data/$source/".$file, "data/$target/".$file);
  }else{
    if($width > $new_width or $height > $new_height){
      my $t = new Image::Thumbnail(
      size       => $new_size,
      module     => "Image::Magick",
      attr       => {colorspace=>'RGB'},
      create     => 1,
      input      => "data/$source/".$file,
      quality    => 90,
      outputpath => "data/$target/".$file,
      );
    }else{
      my $t = new Image::Thumbnail(
      size       => $width.'x'.$height,
      module     => "Image::Magick",
      attr       => {colorspace=>'RGB'},
      create     => 1,
      input      => "data/$source/".$file,
      quality    => 90,
      outputpath => "data/$source/".$file,
      );
    }
  }
}


sub get_display_key {
    my $salt = shift || rand(999);
    require Digest::SHA1;
    return substr(Digest::SHA1::sha1_hex($salt.time().$conf->{Misc}->{Key}),10,30);
}

sub format_name {
  my $str = shift;
  $str =~ s/,//g;
  $str =~ s/<//g;
  $str =~ s/>//g;
  return (join " ", map {ucfirst} split " ", $str),
}


sub format_short_name {
    my $str = shift;
    $str =~ s/,//g;
    $str =~ s/<//g;
    $str =~ s/>//g;
    my @words = split(" ",$str);
    my $name = '';
    foreach my $word (@words){
        if($name){
            $name .= ' '.ucfirst($word);
            return $name;
        }else{
            $name = ucfirst($word);
        }
    }
    return $name;
}


sub upload_usr_file {
  my $cgi_param = shift || "";
  my $dir = shift || "";
  my $filename = param($cgi_param);
  my $mime = '';
  my $save_as = shift || "";

  if( !(-e "data/$dir")){
    mkdir ("data/$dir");
  }

  if($filename){
    my $type = uploadInfo($filename)->{'Content-Type'};
    my ($name, $extension) = split(/\./, $filename);

    my $file = clean_str($name);

    if($type eq "image/jpeg" or $type eq "image/x-jpeg"  or $type eq "image/pjpeg"){
      $file .= ".jpg";
      $mime = 'img';
    }elsif($type eq "image/png" or $type eq "image/x-png"){
      $file .= ".png";
      $mime = 'img';
    }elsif($type eq "image/gif" or $type eq "image/x-gif"){
      $file .= ".gif";
      $mime = 'img';
    }elsif($filename =~ /\.pdf$/i){
      $file .= ".pdf";
      $mime = 'pdf';
    }elsif($filename =~ /\.doc$/i){
      $file .= ".doc";
      $mime = 'doc';
    }elsif($filename =~ /\.xls$/i){
      $file .= ".xls";
      $mime = 'xls';
    }elsif($filename =~ /\.csv$/i){
      $file .= ".csv";
      $mime = 'csv';
    }elsif($filename =~ /\.ppt$/i){
      $file .= ".ppt";
      $mime = 'ppt';
    }elsif($filename =~ /\.docx$/i){
      $file .= ".docx";
      $mime = 'docx';
    }elsif($filename =~ /\.xlsx$/i){
      $file .= ".xlsx";
      $mime = 'xlsx';
    }elsif($filename =~ /\.pptx$/i){
      $file .= ".pptx";
      $mime = 'pptx';
    }elsif($filename =~ /\.swf$/i){
      $file .= ".swf";
      $mime = 'swf';
    }elsif($filename =~ /\.mp4$/i){
      $file .= ".mp4";
      $mime = 'mp4';
    }elsif($filename =~ /\.zip$/i){
      $file .= ".zip";
      $mime = 'zip';
    }elsif($filename =~ /\.txt$/i){
      $file .= ".txt";
      $mime = 'txt';
    }else{
      msg_add("danger","Solo documentos y zip son soportados.");
      return "";
    }
    if($file){

      if (-e "data/$dir/$file") {
        foreach my $it (1 .. 1000000) {
          $file = $name.'_'.$it.$extension;
          if(!(-e "data/$dir/$file")){
            last;
          }
        }
      }

      open (OUTFILE,">data/$dir/" . $file) or die "$!";
      binmode(OUTFILE);
      my $bytesread;
      my $buffer;
      while ($bytesread=read($filename,$buffer,1024)) {
        print OUTFILE $buffer;
      }
      close(OUTFILE);
      return $file;
    }
  }
  return "";
}

sub clean_str {
  my $cadena = shift;

    $cadena =~ s/\s+/ /g;
    $cadena =~ s/^\W//g;
    $cadena =~ s/\W+$//g;
    $cadena =~ s/\s/_/g;
    $cadena =~ s/\W//g;
    
    return $cadena;
}

sub detect_browser_language {
    my $detected_language = shift || 'en_US';
    if($ENV{HTTP_ACCEPT_LANGUAGE} =~ /es/ ){
        $detected_language = 'es_MX';
    }
    return $detected_language;
}

sub get_url {
    my $title = shift;
    my $key_field = shift || 'entry_id';
    my $table     = shift || 'entries';
    $table =~ s/\W//g;
    my $id = $_REQUEST->{$key_field} || 0;

    $title = substr($title,0,41);
    $title =~ s/á/a/g;
    $title =~ s/é/e/g;
    $title =~ s/í/i/g;
    $title =~ s/ó/o/g;
    $title =~ s/ú/u/g;
    $title =~ s/Á/A/g;
    $title =~ s/É/E/g;
    $title =~ s/Í/I/g;
    $title =~ s/Ó/O/g;
    $title =~ s/Ú/U/g;
    $title =~ s/ñ/n/g;
    $title =~ s/Ñ/N/g;
    $title =~ s/\W//g;
    $title =~ s/\-+$//g;
    $title =~ s/\-\-+/-/g;

    my $exist = $dbh->selectrow_array("SELECT COUNT(*) FROM $table WHERE url_key=? AND $key_field<>?",{},$title, $id);

    if($exist){
        my $t = $dbh->selectrow_array("SELECT COUNT(*) FROM $table WHERE url_key RLIKE ? AND $key_field<>?",{},$title, $id) || 1;
        my $original_title = $title;
        for(my $it = $t; $it <= 100000 ; $it++){
            $title = $original_title.'-'.$it;
            my $exist = $dbh->selectrow_array("SELECT COUNT(*) FROM $table WHERE url_key=? AND $key_field<>?",{},$title,$id);
            last if(!$exist);
        }
    }
    return $title;
}

# sub nav_route {
#     my @items = @_;

#     my $product = shift || "";
#     my $route = '<div class="nav-wrapper"> <li> <a href="/">Inicio</a> </li> ';
#     foreach my $item(@items){
#         if ("ARRAY" eq ref($item)) {
#             my $name = $item->[0];
#             $name = CGI::a({-href=>$item->[1], -class=>'breadcrumb'},$name) if($item->[1]);
#             $route .= $name;
#         }
#     }
#     $route .= '<a class="active">'. $conf->{Page}->{Title} .'</li>';
#     if ("HASH" eq ref($product)) {
#         $route.= ' <div id="divider"></div> <a href="#" id="product">'.$product->{name}.'</a>';
#     }

#     return '<nav class="ws-nav">'.$route.'</nav>';
# }


1;
