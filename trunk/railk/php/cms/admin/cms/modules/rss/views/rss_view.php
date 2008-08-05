<?php
echo '<?xml version="1.0" encoding="utf-8"?>' . "
";
?>
<rss version="2.0"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:sy="http://purl.org/rss/1.0/modules/syndication/"
    xmlns:admin="http://webns.net/mvcb/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:content="http://purl.org/rss/1.0/modules/content/">
 
    <channel>
 
    <title><?=$feed_name;?></title>
<link><?=$feed_url;?></link>
    <description><?=epage_description;?></description>
    <dc:language><?=$page_language;?></dc:language>
    <dc:creator><?=$creator_email;?></dc:creator>
 
    <dc:rights>Copyright <?php=gmdate("Y", time());?></dc:rights>
    <admin:generatorAgent rdf:resource="http://irc.geek.ma/" />
 
    <?php foreach($quotes->result() as $quote): ?>
 
        <item>
 
          <title>Quote #<?= xml_convert($quote->ID) ?></title>
<link><?= site_url('details/' . $quote->ID) ?></link>
          <guid><?= site_url('details/' . $quote->ID) ?></guid>
 
          <description><![CDATA[
          <?= nl2br(htmlentities($quote->Body)) ?>
          ]]></description>
<pubDate><?= date ('r', $quote->DateAddition) ?></pubDate>
        </item>
 
    <?php endforeach; ?>
 
    </channel>
</rss>
