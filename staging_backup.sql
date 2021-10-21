-- MySQL dump 10.13  Distrib 5.7.31, for Linux (x86_64)
--
-- Host: sp6xl8zoyvbumaa2.cbetxkdyhwsb.us-east-1.rds.amazonaws.com    Database: whp7zc1yakvsrhlr
-- ------------------------------------------------------
-- Server version	5.7.33-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `action_mailbox_inbound_emails`
--

DROP TABLE IF EXISTS `action_mailbox_inbound_emails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action_mailbox_inbound_emails` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `status` int(11) NOT NULL DEFAULT '0',
  `message_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message_checksum` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_action_mailbox_inbound_emails_uniqueness` (`message_id`,`message_checksum`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `action_mailbox_inbound_emails`
--

LOCK TABLES `action_mailbox_inbound_emails` WRITE;
/*!40000 ALTER TABLE `action_mailbox_inbound_emails` DISABLE KEYS */;
INSERT INTO `action_mailbox_inbound_emails` VALUES (1,2,'298296781.1655992.1631805387754.JavaMail.yahoo@mail.yahoo.co.jp','9c30d19f595b8508eea4370366f2135e9342ffcf','2021-09-17 00:16:34.807633','2021-09-17 00:16:37.343096');
/*!40000 ALTER TABLE `action_mailbox_inbound_emails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `action_text_rich_texts`
--

DROP TABLE IF EXISTS `action_text_rich_texts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action_text_rich_texts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` longtext COLLATE utf8mb4_unicode_ci,
  `record_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `record_id` bigint(20) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_action_text_rich_texts_uniqueness` (`record_type`,`record_id`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `action_text_rich_texts`
--

LOCK TABLES `action_text_rich_texts` WRITE;
/*!40000 ALTER TABLE `action_text_rich_texts` DISABLE KEYS */;
INSERT INTO `action_text_rich_texts` VALUES (1,'introduction','','User',1,'2021-07-12 16:19:50.061244','2021-07-12 16:19:50.061244'),(2,'content','<div>誰しも一度はあるであろう、オシャレな空間での失敗。<br><br>その中でも<strong>思わず笑ってしまう</strong>ネタをシェアして下さい。<br>これを読んで、事前に気をつけることもできるでしょう！<br><br></div>','Topic',1,'2021-07-13 00:32:03.326412','2021-07-13 00:33:02.128988'),(3,'introduction',NULL,'User',4,'2021-08-21 01:18:31.265754','2021-08-21 01:18:31.265754'),(4,'introduction',NULL,'User',5,'2021-08-21 01:21:25.681720','2021-08-21 01:21:25.681720'),(5,'introduction','','User',6,'2021-08-21 01:24:35.896461','2021-08-25 15:59:31.816526'),(6,'introduction',NULL,'User',7,'2021-08-21 01:26:30.317148','2021-08-21 01:26:30.317148'),(7,'introduction','','User',8,'2021-08-21 01:37:19.266284','2021-08-25 14:09:57.410445'),(8,'introduction','','User',9,'2021-08-21 01:39:39.686105','2021-08-29 10:58:57.348102'),(9,'introduction',NULL,'User',10,'2021-08-21 01:41:04.006620','2021-08-21 01:41:04.006620'),(10,'introduction',NULL,'User',11,'2021-08-21 01:42:57.703048','2021-08-21 01:42:57.703048'),(11,'introduction','','User',12,'2021-08-21 01:44:48.893041','2021-08-25 14:33:51.746311'),(12,'introduction',NULL,'User',13,'2021-08-21 01:47:29.720697','2021-08-21 01:47:29.720697'),(13,'introduction',NULL,'User',14,'2021-08-21 01:49:23.634713','2021-08-21 01:49:23.634713'),(14,'introduction','','User',15,'2021-08-21 01:50:21.206263','2021-08-29 11:53:08.254407'),(15,'introduction',NULL,'User',16,'2021-08-21 14:56:42.334726','2021-08-21 14:56:42.334726'),(16,'introduction',NULL,'User',17,'2021-08-21 14:58:35.440559','2021-08-21 14:58:35.440559'),(17,'introduction','','User',18,'2021-08-21 15:00:39.605715','2021-08-25 14:14:16.185471'),(18,'introduction',NULL,'User',19,'2021-08-21 15:02:42.770758','2021-08-21 15:02:42.770758'),(19,'introduction',NULL,'User',20,'2021-08-21 15:04:07.438844','2021-08-21 15:04:07.438844'),(20,'content','<div>ゴルフに関する鉄板ネタはこちらへどうぞ！！</div>','Topic',2,'2021-08-21 15:38:13.335174','2021-08-21 15:38:13.335174'),(21,'content','<div>野球がらみで面白い話はこちらへ！！</div>','Topic',3,'2021-08-21 15:55:12.325993','2021-08-21 15:55:12.325993'),(22,'content','<div>飛行機で旅行や出張をした際の爆笑ネタがあればこちらでシェアしましょう！</div>','Topic',4,'2021-08-21 16:07:43.860483','2021-08-21 16:07:43.860483'),(23,'content','<div>クルマの運転に関して面白いエピソードはこちらにどうぞ！</div>','Topic',5,'2021-08-21 16:22:01.147178','2021-08-21 16:22:01.147178'),(24,'content','<div>お正月の面白いネタはこちらへどうぞ！?</div>','Topic',6,'2021-08-21 23:46:30.886032','2021-08-21 23:46:30.886032'),(25,'content','<div>ハワイに滞在中の爆笑エピソードなどはこちらへどうぞ！！</div>','Topic',7,'2021-08-21 23:54:50.018897','2021-08-21 23:54:50.018897'),(26,'content','<div>オリンピックにまつわる面白いお話はこちらへどうぞ！！！</div>','Topic',8,'2021-08-22 00:10:35.383192','2021-08-22 00:10:35.383192'),(27,'content','<div>ディズニーでの笑える思い出・エピソードはこちらでお願いします！</div>','Topic',9,'2021-08-22 00:21:22.510866','2021-08-22 00:21:22.510866'),(28,'content','<div>子育てに関しての爆笑エピソードはぜひこちらへ?</div>','Topic',10,'2021-08-22 09:23:56.660960','2021-08-29 11:14:25.621773'),(29,'content','<div>車の運転に関して笑えるエピソードがあれば、こちらにどうぞ！！?</div>','Topic',11,'2021-08-22 09:37:22.967360','2021-08-22 09:37:22.967360'),(30,'content','<div>親戚のおばちゃんがうちの子供にくれたお年玉がシュールすぎた件。<br><action-text-attachment sgid=\"BAh7CEkiCGdpZAY6BkVUSSIyZ2lkOi8vdGVwcGFuL0FjdGl2ZVN0b3JhZ2U6OkJsb2IvMT9leHBpcmVzX2luBjsAVEkiDHB1cnBvc2UGOwBUSSIPYXR0YWNoYWJsZQY7AFRJIg9leHBpcmVzX2F0BjsAVDA=--a567be4ea96e69185ef64faaa49ecf2ef25932e0\" content-type=\"image/jpeg\" url=\"https://www.gentle-cloud.com/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--76a69a705e603fcd5fe99db8a535a4dccca66af0/67B52EBE-8B22-4760-B86E-606E44ABC370.jpeg\" filename=\"67B52EBE-8B22-4760-B86E-606E44ABC370.jpeg\" filesize=\"42012\" width=\"676\" height=\"453\" previewable=\"true\" presentation=\"gallery\"></action-text-attachment></div>','Neta',1,'2021-08-22 10:06:49.279650','2021-08-22 10:19:58.394632'),(31,'valuecontent',NULL,'Neta',1,'2021-08-22 10:06:49.283507','2021-08-22 10:06:49.283507'),(32,'content','<div>去年の夏、やたら日本語や漢字のTシャツやタトゥーをしてる人を見かけました?<br><br>羊、悪女、申年（絵付き）、大麻・・・などなど<br><br>そんなの彫っちゃっていいの～！？とかなり笑ってました（笑）<br><br>でもきっと私の持ってる英語のTシャツも変な意味なんだろうな…、と痛感しましたけど。</div>','Neta',2,'2021-08-24 00:01:54.324103','2021-08-24 00:01:54.324103'),(33,'valuecontent',NULL,'Neta',2,'2021-08-24 00:01:54.329673','2021-08-24 00:01:54.329673'),(34,'content','<div>東京ディズニーリゾートに行くと財布の紐が緩みがち！<br><br>気づいたら必要ではないお土産を買っていることもよくある話ですよね。<br><br></div><div>カチューシャやポシェットやバッグ、現実で使うことが難しいですが、やっぱりかわいいので結局オッケーなんです。<br><br>夢の国に売っているものに無駄なものなど何一つないのです。<br><br></div><div>昔かわいいと思って買ったけれど、一度も使わなかったマフラーを自分の子供が巻いているのを見て、「私の目は正しかった」とドヤ顔になっている私が保証します。</div>','Neta',3,'2021-08-24 00:09:55.466573','2021-08-24 00:12:02.198073'),(35,'valuecontent',NULL,'Neta',3,'2021-08-24 00:09:55.474020','2021-08-24 00:09:55.474020'),(36,'content','<div>私当時5歳。父の運転する車に乗り<br><br>「右の矢印がカチカチしたら右に車が行く、左の矢印がカチカチしたら左に行くのか！」<br><br>と新たな発見に喜んでたところ、、<br><br></div>','Neta',4,'2021-08-24 23:44:20.596318','2021-08-24 23:45:57.633254'),(37,'valuecontent','<div><br>ハザードをつけられ、<br><br><strong>「おどうざん！車が割れる！！」</strong><br><br>と藤原竜也に負けない位に泣き叫んだ事。<br><br><br>（<em>注：これはあくまでサンプルなので、実際は有料ネタはもう少し濃い内容を想定しています）</em></div>','Neta',4,'2021-08-24 23:44:20.605269','2021-08-24 23:45:57.652606'),(38,'content','<div>就職活動中の爆笑エピソードはこちらへどうぞ！！</div>','Topic',12,'2021-08-25 01:41:44.046541','2021-08-25 01:41:44.046541'),(39,'content','<div>美術館での爆笑エピソードはぜひこちらへ！！</div>','Topic',13,'2021-08-25 01:54:55.988924','2021-08-25 01:54:55.988924'),(40,'content','<div>昔、日本からオワフ島で乗り継いでハワイ島まで行った時のことですが、乗り継ぎの便が予定より早く飛んでいってしまって間に合わなかったことがありました。<br><br></div><div>まじで？！なんで？？とかなり焦って「なんか乗る予定の飛行機がもう飛んでいっちゃったんだけど！」と係の人に一生懸命訴えたら、適当にぐちゃって手書きで書いた感じの臨時チケットを渡され、次の便に乗せられました。<br><br></div><div>予防策は特にないのですが、ハワイだと時々あるらしいです。怖かった。</div>','Neta',5,'2021-08-29 01:00:59.605873','2021-08-29 01:00:59.605873'),(41,'valuecontent',NULL,'Neta',5,'2021-08-29 01:00:59.612296','2021-08-29 01:00:59.612296'),(42,'content','<div>クリスマス前、時間にあわせて空港についたところ<strong>オーバーブッキングなので明日出直してこい</strong>と言われ、なんどお願いしても「ダメだ」と突っぱねられました。<br><br>が、<br><strong>「ブラジルの友達とクリスマスをすごす予定が台無しだ。クリスマスに友達と会いたかったのに」<br>と言った途端、窓口の態度が一変。</strong><br><br>「それは大問題です。必ずクリスマスに間に合わせます」と、バンクーバー→トロント→サンパウロとチケットをつないでクリスマスに間に合わせてくれました。<br><br>今はなきヴァリグブラジル航空でしたが、キリスト教国にとってクリスマスがどれほど大事なことなのかを実感しました。</div>','Neta',6,'2021-08-29 01:10:09.164557','2021-08-29 01:27:50.059792'),(43,'valuecontent',NULL,'Neta',6,'2021-08-29 01:10:09.170570','2021-08-29 01:10:09.170570'),(44,'content','<div>USのとある空港にテロだか何だかの情報が入り、その犯人が中国人ということで、日本人の友人も取り調べの対象になったそうな。<br><br></div><div>英語がさほど堪能でない彼は、身振り手振りも交えて間違いなくパスポートの本人で単に旅行に来ているだけと、ようやく納得してもらい解放されることに。<br><br></div><div>そこで何をトチ狂ったか、取り調べの部屋から出る時「シェイシェイ(謝謝)」と言ったもんだから、即取り押さえられ数時間取り調べを受けることとなったのだそうな。</div>','Neta',7,'2021-08-29 01:34:08.969757','2021-08-29 01:34:08.969757'),(45,'valuecontent',NULL,'Neta',7,'2021-08-29 01:34:08.973966','2021-08-29 01:34:08.973966'),(46,'content','<div>もしかしたら、今日はやれるかもしれない。<br><br></div><div>練習場での調子はバツグンだった。<br><br></div><div>新しいアイアンに変えた。<br><br></div><div>理由はたくさんあります。<br><br></div><div>でも、ティーショットの瞬間、悲しい気持ちになることが多いのは何故でしょう．．．</div><div><br></div>','Neta',8,'2021-08-29 01:41:20.344920','2021-08-29 01:41:20.344920'),(47,'valuecontent',NULL,'Neta',8,'2021-08-29 01:41:20.349051','2021-08-29 01:41:20.349051'),(48,'content','<div>ゴルフは、紳士のスポーツです。<br><br></div><div>心も紳士でありたいものです。<br><br></div><div>でも、人間である以上、口に出さなくても思ってしまうことは、仕方ありません。<br><br></div><div>ティーイングエリアで握っている相手が打つときに、ミスれと念じてしまう。<br><br></div><div>グリーンで握っている相手が打つときに、ミスれと念じてしまう。<br><br></div><div>なるべくならやめましょう。<br><br></div><div>せめて心の声が漏れないように気をつけて下さい。</div>','Neta',9,'2021-08-29 01:49:28.440564','2021-08-29 01:49:28.440564'),(49,'valuecontent',NULL,'Neta',9,'2021-08-29 01:49:28.444535','2021-08-29 01:49:28.444535'),(50,'content','<div><br><br></div><blockquote><strong>「ママ」を覚えた！次はパパは？</strong></blockquote><div><br><action-text-attachment sgid=\"BAh7CEkiCGdpZAY6BkVUSSIyZ2lkOi8vdGVwcGFuL0FjdGl2ZVN0b3JhZ2U6OkJsb2IvMj9leHBpcmVzX2luBjsAVEkiDHB1cnBvc2UGOwBUSSIPYXR0YWNoYWJsZQY7AFRJIg9leHBpcmVzX2F0BjsAVDA=--c2fa0f940a2f54d4070a18a45bc0022ba11770db\" content-type=\"image/jpeg\" url=\"https://www.gentle-cloud.com/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--31b83b9a95fd7763e429c607e622314d35df40df/mamma17-1.jpeg\" filename=\"mamma17-1.jpeg\" filesize=\"35354\" width=\"400\" height=\"285\" previewable=\"true\" presentation=\"gallery\"></action-text-attachment>「ママ」を覚えた息子くん。</div><div><br></div><div><strong>次に覚える言葉は…</strong><br><strong>やっぱり「パパ」？<br></strong><br></div><div>その言葉が聞きたくて、パパは奮闘します。<br><br><action-text-attachment sgid=\"BAh7CEkiCGdpZAY6BkVUSSIyZ2lkOi8vdGVwcGFuL0FjdGl2ZVN0b3JhZ2U6OkJsb2IvMz9leHBpcmVzX2luBjsAVEkiDHB1cnBvc2UGOwBUSSIPYXR0YWNoYWJsZQY7AFRJIg9leHBpcmVzX2F0BjsAVDA=--6e19dda7c11a63400b1e4591a7036c58774b8080\" content-type=\"image/jpeg\" url=\"https://www.gentle-cloud.com/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDQT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--43cc579dc7211e55b3f11d47d70191b2827ccf21/mamma17-2.jpeg\" filename=\"mamma17-2.jpeg\" filesize=\"86749\" width=\"400\" height=\"596\" previewable=\"true\" presentation=\"gallery\"></action-text-attachment><strong>「パパって言ってごらん」<br>「・・・。」<br></strong><br></div><div>たっぷりタメて、息子くんから出した言葉は…<br><br><action-text-attachment sgid=\"BAh7CEkiCGdpZAY6BkVUSSIyZ2lkOi8vdGVwcGFuL0FjdGl2ZVN0b3JhZ2U6OkJsb2IvND9leHBpcmVzX2luBjsAVEkiDHB1cnBvc2UGOwBUSSIPYXR0YWNoYWJsZQY7AFRJIg9leHBpcmVzX2F0BjsAVDA=--1a726c51078390032067f75cba9fef8373f3319f\" content-type=\"image/jpeg\" url=\"https://www.gentle-cloud.com/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--32fb80cdf0113d6434340b0c55678dd5a0c0453c/mamma17-3.jpeg\" filename=\"mamma17-3.jpeg\" filesize=\"30867\" width=\"400\" height=\"289\" previewable=\"true\" presentation=\"gallery\"></action-text-attachment><br><br><br><br><br></div><blockquote><strong>ついに、念願の「パパ」が…？</strong></blockquote><div><br><action-text-attachment sgid=\"BAh7CEkiCGdpZAY6BkVUSSIyZ2lkOi8vdGVwcGFuL0FjdGl2ZVN0b3JhZ2U6OkJsb2IvNT9leHBpcmVzX2luBjsAVEkiDHB1cnBvc2UGOwBUSSIPYXR0YWNoYWJsZQY7AFRJIg9leHBpcmVzX2F0BjsAVDA=--4d76c0ada0966473195ae2d701e7ed569eb6512b\" content-type=\"image/jpeg\" url=\"https://www.gentle-cloud.com/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--c4b30ef0f937268daf317fa39680947394fb26b3/mamma17-9.jpeg\" filename=\"mamma17-9.jpeg\" filesize=\"66598\" width=\"399\" height=\"597\" previewable=\"true\" presentation=\"gallery\"></action-text-attachment><br><br><strong>「パパ」を連呼する息子！<br></strong><br></div><div>しかしその相手は…<br><br></div><div>パパ…<br><br></div><div>ではなく…？？？<br><br><action-text-attachment sgid=\"BAh7CEkiCGdpZAY6BkVUSSIyZ2lkOi8vdGVwcGFuL0FjdGl2ZVN0b3JhZ2U6OkJsb2IvNz9leHBpcmVzX2luBjsAVEkiDHB1cnBvc2UGOwBUSSIPYXR0YWNoYWJsZQY7AFRJIg9leHBpcmVzX2F0BjsAVDA=--7127cd78ee002ac781b7a77ab2febcb8a0e3404b\" content-type=\"image/jpeg\" url=\"https://www.gentle-cloud.com/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBEQT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--ce33b56ac4704a2cfdad3903c81fee5761e4b983/mamma17-10.jpeg\" filename=\"mamma17-10.jpeg\" filesize=\"36547\" width=\"398\" height=\"290\" previewable=\"true\" presentation=\"gallery\"></action-text-attachment><strong><br><br></strong>それは本体じゃないよー！<br>でもおしい！あと一歩！</div>','Neta',10,'2021-08-29 11:21:38.708675','2021-08-29 11:33:05.479133'),(51,'valuecontent',NULL,'Neta',10,'2021-08-29 11:21:38.763806','2021-08-29 11:21:38.763806'),(52,'body','<h3>ようこそ</h3>\n<p>Stripe は、インターネットにおける経済的なインフラストラクチャーを提供しています。オンラインの決済および業務管理の導入のための当社のソフトウェアおよびサービスをあらゆる規模の企業にご利用いただいており、当社がお預かりする個人データのセキュリティおよびプライバシーについては細心の注意を払っています。</p>\n<p>本ポリシーでは、当社が収集する<a style=\"color:#5469d4;background-color:transparent\" href=\"https://stripe.com/jp/privacy#personal-data-definition-ja\" target=\"_blank\">個人データ</a>、当社による個人データの使用および共有の方法、個人データに関するお客様の権利および選択肢、ならびにプライバシーの取り扱いに関するお問い合わせ方法について説明しています。</p>','Emailrec',1,'2021-09-17 00:16:37.313615','2021-09-17 00:16:37.313615'),(53,'introduction',NULL,'User',3,'2021-10-03 18:30:57.744885','2021-10-03 18:30:57.744885'),(60,'content','<div><br><strong>タワーオブテラーは高さが59mと超中途半端。<br><br></strong>私だったら切りよく60mにします。<br><br></div><div>間違いない！<br><br></div><div>アナタだってそうするでしょう？？<br><br></div><div>60mにしませんか？<br><br></div><div><strong>だけど実は59という数図は深い怖い意味があるらしい・・・<br></strong><br></div><div>呪いの数字だという都市伝説も。<br><br><strong>都市伝説では5と9という数字が忌み数で呪われているから59mなのだという噂があります。<br></strong><br></div><div>タワーオブテラーはディズニーシーのお化け屋敷的アトラクション。<br><br></div><div>そういう都市伝説があっても不思議ではない・・・<br><br></div><div>でも本当は違うんだ！<br><br></div><div><strong>59ｍにはディズニーのポリシーが詰め込まれています。<br></strong><br></div><div>ディズニーン魔法の神髄が59の中に詰め込まれていました。<br><br></div>','Neta',14,'2021-10-03 23:34:10.108862','2021-10-03 23:34:52.741094'),(61,'valuecontent','<div><br><br>実は60mの高さにすると航空法に引っかかって赤か白のライトを付けなくてはいけない決まり。<br><br></div><div>タワーオブテラーの屋上に変なライトがピカピカしてたらどうだろうか？<br><br></div><div><strong>ディズニーが世界観を壊さないために59mの高さに抑えていたのです。<br></strong><br></div><div>ちょっと笑えるディズニーの面白い都市伝説とディズニーのトリビアでした。<br><br></div>','Neta',14,'2021-10-03 23:34:10.112875','2021-10-03 23:34:29.930744');
/*!40000 ALTER TABLE `action_text_rich_texts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `active_storage_attachments`
--

DROP TABLE IF EXISTS `active_storage_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `active_storage_attachments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8_unicode_ci NOT NULL,
  `record_type` varchar(191) COLLATE utf8_unicode_ci NOT NULL,
  `record_id` bigint(20) NOT NULL,
  `blob_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_active_storage_attachments_uniqueness` (`record_type`,`record_id`,`name`,`blob_id`),
  KEY `index_active_storage_attachments_on_blob_id` (`blob_id`),
  CONSTRAINT `fk_rails_c3b3935057` FOREIGN KEY (`blob_id`) REFERENCES `active_storage_blobs` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active_storage_attachments`
--

LOCK TABLES `active_storage_attachments` WRITE;
/*!40000 ALTER TABLE `active_storage_attachments` DISABLE KEYS */;
INSERT INTO `active_storage_attachments` VALUES (1,'embeds','ActionText::RichText',30,1,'2021-08-22 10:15:09'),(2,'embeds','ActionText::RichText',50,2,'2021-08-29 11:21:38'),(3,'embeds','ActionText::RichText',50,3,'2021-08-29 11:21:38'),(4,'embeds','ActionText::RichText',50,4,'2021-08-29 11:21:38'),(5,'embeds','ActionText::RichText',50,5,'2021-08-29 11:30:21'),(6,'embeds','ActionText::RichText',50,7,'2021-08-29 11:30:21'),(7,'raw_email','ActionMailbox::InboundEmail',1,8,'2021-09-17 00:16:34'),(8,'attachments','Emailrec',1,9,'2021-09-17 00:16:37');
/*!40000 ALTER TABLE `active_storage_attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `active_storage_blobs`
--

DROP TABLE IF EXISTS `active_storage_blobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `active_storage_blobs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(191) COLLATE utf8_unicode_ci NOT NULL,
  `filename` varchar(191) COLLATE utf8_unicode_ci NOT NULL,
  `content_type` varchar(191) COLLATE utf8_unicode_ci DEFAULT NULL,
  `metadata` text COLLATE utf8_unicode_ci,
  `byte_size` bigint(20) NOT NULL,
  `checksum` varchar(191) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_active_storage_blobs_on_key` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active_storage_blobs`
--

LOCK TABLES `active_storage_blobs` WRITE;
/*!40000 ALTER TABLE `active_storage_blobs` DISABLE KEYS */;
INSERT INTO `active_storage_blobs` VALUES (1,'0424p3ah0izotuo7847y5369orh2','67B52EBE-8B22-4760-B86E-606E44ABC370.jpeg','image/jpeg','{\"identified\":true,\"width\":676,\"height\":453,\"analyzed\":true}',42012,'5Q/F00x+GS9/CuzdmhIWXw==','2021-08-22 10:14:36'),(2,'d2czln3cc5uq6zqvy6wp82yvenwl','mamma17-1.jpeg','image/jpeg','{\"identified\":true,\"width\":400,\"height\":285,\"analyzed\":true}',35354,'0OS5vmIy6K+6wgF7LtNGCA==','2021-08-29 11:18:18'),(3,'qoxwg1hb90vhly05q3pij62w7dvi','mamma17-2.jpeg','image/jpeg','{\"identified\":true,\"width\":400,\"height\":596,\"analyzed\":true}',86749,'6oNTtAsvqVP3kLRQBiCltA==','2021-08-29 11:19:31'),(4,'b5sreyesf8bvm9jitiafb42dji3m','mamma17-3.jpeg','image/jpeg','{\"identified\":true,\"width\":400,\"height\":289,\"analyzed\":true}',30867,'2G4UfNpfiYtPHOq2DtHgzA==','2021-08-29 11:20:06'),(5,'duekdwm8p5elyni8k2ijj3uwybji','mamma17-9.jpeg','image/jpeg','{\"identified\":true,\"width\":399,\"height\":597,\"analyzed\":true}',66598,'tP/vXzekxt80s0O70XzHDQ==','2021-08-29 11:23:39'),(6,'82f9o0njwpfti290p57cp4p1eji6','mamma17-10.jpeg','image/jpeg',NULL,36547,'FzcTdZIWE42GGoFnHErRww==','2021-08-29 11:24:09'),(7,'uidgsmga07azrzarwkaaah4mznn3','mamma17-10.jpeg','image/jpeg','{\"identified\":true,\"width\":398,\"height\":290,\"analyzed\":true}',36547,'FzcTdZIWE42GGoFnHErRww==','2021-08-29 11:30:11'),(8,'36kcxjehommd7aij5pn76697yf7j','message.eml','message/rfc822','{\"identified\":true,\"analyzed\":true}',178619,'c2V3I3KktWtz2H188lBmZQ==','2021-09-17 00:16:34'),(9,'12e0ppm5w2jyuywalfllm5dywe28','olympic.jpeg','image/jpeg','{\"identified\":true,\"width\":800,\"height\":500,\"analyzed\":true}',127088,'oVmeNLv6jfFeyVn9cAQIOA==','2021-09-17 00:16:36');
/*!40000 ALTER TABLE `active_storage_blobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ar_internal_metadata`
--

DROP TABLE IF EXISTS `ar_internal_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ar_internal_metadata` (
  `key` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ar_internal_metadata`
--

LOCK TABLES `ar_internal_metadata` WRITE;
/*!40000 ALTER TABLE `ar_internal_metadata` DISABLE KEYS */;
INSERT INTO `ar_internal_metadata` VALUES ('environment','production','2021-07-12 14:02:05.364724','2021-07-12 14:02:05.364724');
/*!40000 ALTER TABLE `ar_internal_metadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `banks`
--

DROP TABLE IF EXISTS `banks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `banks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(191) NOT NULL DEFAULT '',
  `name` varchar(191) NOT NULL DEFAULT '',
  `namekana` varchar(191) NOT NULL DEFAULT '',
  `namehira` varchar(191) NOT NULL DEFAULT '',
  `roma` varchar(191) NOT NULL DEFAULT '',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_banks_on_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banks`
--

LOCK TABLES `banks` WRITE;
/*!40000 ALTER TABLE `banks` DISABLE KEYS */;
INSERT INTO `banks` VALUES (1,'1100','STRIPE TEST BANK','STRIPE TEST BANK','STRIPE TEST BANK','STRIPE TEST BANK','2021-08-23 16:15:55','2021-08-23 16:15:55');
/*!40000 ALTER TABLE `banks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bookmarks`
--

DROP TABLE IF EXISTS `bookmarks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bookmarks` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bookmarkable_id` int(11) DEFAULT NULL,
  `bookmarkable_type` varchar(191) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_bookmark` (`user_id`,`bookmarkable_type`,`bookmarkable_id`),
  CONSTRAINT `fk_rails_c1ff6fa4ac` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookmarks`
--

LOCK TABLES `bookmarks` WRITE;
/*!40000 ALTER TABLE `bookmarks` DISABLE KEYS */;
INSERT INTO `bookmarks` VALUES (1,8,'Topic',18,'2021-08-22 10:02:07','2021-08-22 10:02:07'),(2,6,'Topic',18,'2021-08-23 22:25:29','2021-08-23 22:25:29'),(3,11,'Topic',15,'2021-08-25 00:15:25','2021-08-25 00:15:25'),(4,10,'Topic',18,'2021-08-29 11:41:22','2021-08-29 11:41:22');
/*!40000 ALTER TABLE `bookmarks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `branches`
--

DROP TABLE IF EXISTS `branches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `branches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(191) NOT NULL DEFAULT '',
  `name` varchar(191) NOT NULL DEFAULT '',
  `namekana` varchar(191) NOT NULL DEFAULT '',
  `namehira` varchar(191) NOT NULL DEFAULT '',
  `roma` varchar(191) NOT NULL DEFAULT '',
  `bank_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_branches_on_bank_id_and_code` (`bank_id`,`code`),
  CONSTRAINT `fk_rails_4ac30aa3f9` FOREIGN KEY (`bank_id`) REFERENCES `banks` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `branches`
--

LOCK TABLES `branches` WRITE;
/*!40000 ALTER TABLE `branches` DISABLE KEYS */;
INSERT INTO `branches` VALUES (1,'000','STRIPE TEST BRANCH','STRIPE TEST BRANCH','STRIPE TEST BRANCH','STRIPE TEST BRANCH',1,'2021-08-23 16:17:44','2021-08-23 16:17:44');
/*!40000 ALTER TABLE `branches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `text` mediumtext,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `commentable_id` int(11) DEFAULT NULL,
  `commentable_type` varchar(191) DEFAULT NULL,
  `likes_count` int(11) NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_rails_03de2dc08c` (`user_id`),
  CONSTRAINT `fk_rails_03de2dc08c` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `copycheck_statuses`
--

DROP TABLE IF EXISTS `copycheck_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `copycheck_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` varchar(191) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `copycheck_statuses`
--

LOCK TABLES `copycheck_statuses` WRITE;
/*!40000 ALTER TABLE `copycheck_statuses` DISABLE KEYS */;
/*!40000 ALTER TABLE `copycheck_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `copycheck_textlikes`
--

DROP TABLE IF EXISTS `copycheck_textlikes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `copycheck_textlikes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `queue_id` int(11) DEFAULT NULL,
  `like_queue_id` int(11) DEFAULT NULL,
  `percent` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `copycheck_textlikes`
--

LOCK TABLES `copycheck_textlikes` WRITE;
/*!40000 ALTER TABLE `copycheck_textlikes` DISABLE KEYS */;
/*!40000 ALTER TABLE `copycheck_textlikes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `copycheck_weblikes`
--

DROP TABLE IF EXISTS `copycheck_weblikes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `copycheck_weblikes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `queue_id` int(11) DEFAULT NULL,
  `distance` int(11) DEFAULT NULL,
  `url` varchar(191) DEFAULT NULL,
  `text` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `copycheck_weblikes`
--

LOCK TABLES `copycheck_weblikes` WRITE;
/*!40000 ALTER TABLE `copycheck_weblikes` DISABLE KEYS */;
/*!40000 ALTER TABLE `copycheck_weblikes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `copychecks`
--

DROP TABLE IF EXISTS `copychecks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `copychecks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `neta_id` int(11) DEFAULT NULL,
  `web_like_status` int(11) DEFAULT NULL,
  `web_like_percent` int(11) DEFAULT NULL,
  `web_match_status` int(11) DEFAULT NULL,
  `web_match_percent` int(11) DEFAULT NULL,
  `text_match_status` int(11) DEFAULT NULL,
  `text_match_percent` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `queue_id` int(11) DEFAULT NULL,
  `text` mediumtext,
  PRIMARY KEY (`id`),
  KEY `fk_rails_95e11130c3` (`neta_id`),
  CONSTRAINT `fk_rails_95e11130c3` FOREIGN KEY (`neta_id`) REFERENCES `netas` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `copychecks`
--

LOCK TABLES `copychecks` WRITE;
/*!40000 ALTER TABLE `copychecks` DISABLE KEYS */;
/*!40000 ALTER TABLE `copychecks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emailrecs`
--

DROP TABLE IF EXISTS `emailrecs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emailrecs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `subject` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emailrecs`
--

LOCK TABLES `emailrecs` WRITE;
/*!40000 ALTER TABLE `emailrecs` DISABLE KEYS */;
INSERT INTO `emailrecs` VALUES (1,'ryo_n_1104@yahoo.co.jp','hogehoge@gentle-cloud.com','2021-09-17 00:16:37.301862','2021-09-17 00:16:37.327308','テストテストメール3（添付つき）');
/*!40000 ALTER TABLE `emailrecs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `follows`
--

DROP TABLE IF EXISTS `follows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `follows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `follower_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `followed_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_follows_on_follower_id_and_followed_id` (`follower_id`,`followed_id`),
  KEY `index_follows_on_follower_id` (`follower_id`),
  KEY `index_follows_on_followed_id` (`followed_id`),
  CONSTRAINT `fk_rails_5ef72a3867` FOREIGN KEY (`followed_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `follows`
--

LOCK TABLES `follows` WRITE;
/*!40000 ALTER TABLE `follows` DISABLE KEYS */;
/*!40000 ALTER TABLE `follows` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hashtag_hits`
--

DROP TABLE IF EXISTS `hashtag_hits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hashtag_hits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hashtag_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_rails_42fb40a9cb` (`hashtag_id`),
  KEY `fk_rails_d4395efe2f` (`user_id`),
  CONSTRAINT `fk_rails_42fb40a9cb` FOREIGN KEY (`hashtag_id`) REFERENCES `hashtags` (`id`),
  CONSTRAINT `fk_rails_d4395efe2f` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hashtag_hits`
--

LOCK TABLES `hashtag_hits` WRITE;
/*!40000 ALTER TABLE `hashtag_hits` DISABLE KEYS */;
INSERT INTO `hashtag_hits` VALUES (1,3,18,'2021-08-23 22:21:22','2021-08-23 22:21:22'),(2,4,9,'2021-08-24 00:24:40','2021-08-24 00:24:40'),(3,10,15,'2021-08-25 00:16:02','2021-08-25 00:16:02'),(4,11,16,'2021-08-25 01:52:49','2021-08-25 01:52:49'),(5,2,15,'2021-08-26 22:41:05','2021-08-26 22:41:05'),(6,4,15,'2021-08-30 00:05:18','2021-08-30 00:05:18');
/*!40000 ALTER TABLE `hashtag_hits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hashtag_netas`
--

DROP TABLE IF EXISTS `hashtag_netas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hashtag_netas` (
  `neta_id` int(11) DEFAULT NULL,
  `hashtag_id` int(11) DEFAULT NULL,
  UNIQUE KEY `index_hashtag_netas_on_neta_id_and_hashtag_id` (`neta_id`,`hashtag_id`),
  KEY `fk_rails_4423013fcc` (`hashtag_id`),
  CONSTRAINT `fk_rails_3d60df3f43` FOREIGN KEY (`neta_id`) REFERENCES `netas` (`id`),
  CONSTRAINT `fk_rails_4423013fcc` FOREIGN KEY (`hashtag_id`) REFERENCES `hashtags` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hashtag_netas`
--

LOCK TABLES `hashtag_netas` WRITE;
/*!40000 ALTER TABLE `hashtag_netas` DISABLE KEYS */;
INSERT INTO `hashtag_netas` VALUES (1,1),(1,2),(1,3),(2,4),(2,5),(3,6),(3,7),(3,8),(3,9),(4,11),(4,12),(4,13),(5,14),(5,15),(5,16),(7,17),(7,18),(8,19),(10,20),(10,21);
/*!40000 ALTER TABLE `hashtag_netas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hashtags`
--

DROP TABLE IF EXISTS `hashtags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hashtags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hashname` varchar(191) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `hit_count` int(11) NOT NULL DEFAULT '0',
  `neta_count` int(11) NOT NULL DEFAULT '0',
  `yomigana` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_hashtags_on_hashname` (`hashname`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hashtags`
--

LOCK TABLES `hashtags` WRITE;
/*!40000 ALTER TABLE `hashtags` DISABLE KEYS */;
INSERT INTO `hashtags` VALUES (1,'お年玉','2021-08-22 10:19:59','2021-08-22 10:19:59',0,1,'おとしだま'),(2,'諭吉','2021-08-22 10:19:59','2021-08-22 10:19:59',1,1,'ゆきち'),(3,'正月','2021-08-22 10:20:00','2021-08-22 10:20:00',1,1,'しょうがつ'),(4,'ハワイ','2021-08-24 00:01:55','2021-08-24 00:01:55',2,1,'はわい'),(5,'タトゥー','2021-08-24 00:01:55','2021-08-24 00:01:55',0,1,'たとぅー'),(6,'お土産','2021-08-24 00:12:02','2021-08-24 00:12:02',0,1,'おみやげ'),(7,'ディズニー','2021-08-24 00:12:03','2021-08-24 00:12:03',0,1,'でぃずにー'),(8,'夢の国','2021-08-24 00:12:03','2021-08-24 00:12:03',0,1,'ゆめのくに'),(9,'魔法のおかげ','2021-08-24 00:12:04','2021-08-24 00:12:04',0,1,'まほうのおかげ'),(10,'車のウィンカー','2021-08-24 23:44:21','2021-08-24 23:44:21',1,0,'くるまのうぃんかー'),(11,'運転','2021-08-24 23:44:21','2021-08-24 23:44:21',1,1,'うんてん'),(12,'ドライブ','2021-08-24 23:44:22','2021-08-24 23:44:22',0,1,'どらいぶ'),(13,'子供の発想はすごい','2021-08-24 23:47:12','2021-08-24 23:47:12',0,1,'こどものはっそうはすごい'),(14,'ハワイでも外国','2021-08-29 01:01:00','2021-08-29 01:01:00',0,1,'はわいでもがいこく'),(15,'飛行機乗り継ぎ','2021-08-29 01:01:00','2021-08-29 01:01:00',0,1,'ひこうきのりつぎ'),(16,'フライト','2021-08-29 01:01:01','2021-08-29 01:01:01',0,1,'ふらいと'),(17,'欧米ではみんなアジア人','2021-08-29 01:34:09','2021-08-29 01:34:09',0,1,'おうべいではみんなあじあじん'),(18,'空港','2021-08-29 01:34:10','2021-08-29 01:34:10',0,1,'くうこう'),(19,'空回りもゴルフです','2021-08-29 01:41:21','2021-08-29 01:41:21',0,1,'からまわりもごるふです'),(20,'幼児','2021-08-29 11:33:06','2021-08-29 11:33:06',0,1,'ようじ'),(21,'育児マンガ','2021-08-29 11:33:06','2021-08-29 11:33:06',0,1,'いくじまんが');
/*!40000 ALTER TABLE `hashtags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inquiries`
--

DROP TABLE IF EXISTS `inquiries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inquiries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inquiries`
--

LOCK TABLES `inquiries` WRITE;
/*!40000 ALTER TABLE `inquiries` DISABLE KEYS */;
/*!40000 ALTER TABLE `inquiries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `likes`
--

DROP TABLE IF EXISTS `likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `likeable_id` int(11) DEFAULT NULL,
  `likeable_type` varchar(191) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_like` (`user_id`,`likeable_type`,`likeable_id`),
  CONSTRAINT `fk_rails_1e09b5dabf` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `likes`
--

LOCK TABLES `likes` WRITE;
/*!40000 ALTER TABLE `likes` DISABLE KEYS */;
INSERT INTO `likes` VALUES (1,2,1,'Topic','2021-07-19 18:58:45','2021-07-19 18:58:45'),(2,10,6,'Topic','2021-08-22 00:00:08','2021-08-22 00:00:08');
/*!40000 ALTER TABLE `likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `netas`
--

DROP TABLE IF EXISTS `netas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `netas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `title` mediumtext,
  `price` int(11) DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `topic_id` int(11) DEFAULT NULL,
  `reviews_count` int(11) NOT NULL DEFAULT '0',
  `pageviews_count` int(11) NOT NULL DEFAULT '0',
  `average_rate` float DEFAULT '0',
  `bookmarks_count` int(11) NOT NULL DEFAULT '0',
  `private_flag` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_rails_128dac0d75` (`user_id`),
  KEY `fk_rails_db6e4640ce` (`topic_id`),
  CONSTRAINT `fk_rails_128dac0d75` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_db6e4640ce` FOREIGN KEY (`topic_id`) REFERENCES `topics` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `netas`
--

LOCK TABLES `netas` WRITE;
/*!40000 ALTER TABLE `netas` DISABLE KEYS */;
INSERT INTO `netas` VALUES (1,18,'親戚のおばちゃんのお年玉',0,'2021-08-22 10:06:49','2021-08-24 00:20:14',6,3,8,4,0,0),(2,18,'日本語のタトゥー',0,'2021-08-24 00:01:54','2021-08-24 00:24:09',7,1,3,3,0,0),(3,18,'家に帰ると何故これ買ったんだろうというお土産がある',0,'2021-08-24 00:09:55','2021-08-29 01:42:46',9,2,3,2.5,0,0),(4,18,'ウィンカー',100,'2021-08-24 23:44:20','2021-10-03 22:43:11',11,3,8,3.67,0,0),(5,9,'フライト乗り継ぎ',0,'2021-08-29 01:00:59','2021-09-06 17:14:51',7,3,5,2.33,0,0),(6,9,'クリスマスのブラジルの空港',0,'2021-08-29 01:10:09','2021-08-29 01:35:57',4,1,3,3,0,0),(7,7,'中国人と間違えられ',0,'2021-08-29 01:34:08','2021-08-29 11:49:21',4,1,2,3,0,0),(8,7,'ティーショットまでが楽しい',0,'2021-08-29 01:41:20','2021-09-06 17:15:30',2,3,4,2.67,0,0),(9,4,'同伴者のミスを念じる',0,'2021-08-29 01:49:28','2021-08-29 11:40:44',2,2,3,3,0,0),(10,9,'パパと呼ばれたい父',0,'2021-08-29 11:21:38','2021-08-29 11:55:53',10,2,5,3.5,0,0),(14,18,'タワーオブテラーの都市伝説',150,'2021-10-03 23:34:10','2021-10-03 23:45:36',9,2,3,2,0,0);
/*!40000 ALTER TABLE `netas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pageviews`
--

DROP TABLE IF EXISTS `pageviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pageviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pageviewable_id` int(11) DEFAULT NULL,
  `pageviewable_type` varchar(191) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_rails_3fdda99dcd` (`user_id`),
  CONSTRAINT `fk_rails_3fdda99dcd` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pageviews`
--

LOCK TABLES `pageviews` WRITE;
/*!40000 ALTER TABLE `pageviews` DISABLE KEYS */;
INSERT INTO `pageviews` VALUES (1,1,'Topic',1,'2021-07-13 00:32:09','2021-07-13 00:32:09'),(2,1,'Topic',1,'2021-07-14 16:16:36','2021-07-14 16:16:36'),(3,1,'Topic',2,'2021-07-19 18:58:42','2021-07-19 18:58:42'),(4,1,'Topic',9,'2021-08-21 15:35:12','2021-08-21 15:35:12'),(5,2,'Topic',9,'2021-08-21 15:38:33','2021-08-21 15:38:33'),(6,3,'Topic',7,'2021-08-21 16:01:10','2021-08-21 16:01:10'),(7,4,'Topic',5,'2021-08-21 16:07:53','2021-08-21 16:07:53'),(8,5,'Topic',13,'2021-08-21 16:22:13','2021-08-21 16:22:13'),(9,6,'Topic',11,'2021-08-21 23:46:33','2021-08-21 23:46:33'),(10,7,'Topic',10,'2021-08-21 23:55:24','2021-08-21 23:55:24'),(11,6,'Topic',10,'2021-08-22 00:00:00','2021-08-22 00:00:00'),(12,8,'Topic',6,'2021-08-22 00:10:37','2021-08-22 00:10:37'),(13,9,'Topic',12,'2021-08-22 00:30:01','2021-08-22 00:30:01'),(14,1,'Topic',1,'2021-08-22 00:35:56','2021-08-22 00:35:56'),(15,9,'Topic',10,'2021-08-22 00:41:06','2021-08-22 00:41:06'),(16,8,'Topic',1,'2021-08-22 07:21:12','2021-08-22 07:21:12'),(17,10,'Topic',17,'2021-08-22 09:24:15','2021-08-22 09:24:15'),(18,4,'Topic',17,'2021-08-22 09:31:36','2021-08-22 09:31:36'),(19,11,'Topic',18,'2021-08-22 09:37:38','2021-08-22 09:37:38'),(20,1,'Topic',18,'2021-08-22 10:00:25','2021-08-22 10:00:25'),(21,9,'Topic',18,'2021-08-22 10:00:57','2021-08-22 10:00:57'),(22,8,'Topic',18,'2021-08-22 10:02:01','2021-08-22 10:02:01'),(23,6,'Topic',18,'2021-08-22 10:04:13','2021-08-22 10:04:13'),(24,1,'Neta',18,'2021-08-22 10:06:49','2021-08-22 10:06:49'),(25,6,'Topic',1,'2021-08-23 01:50:32','2021-08-23 01:50:32'),(26,1,'Neta',18,'2021-08-23 22:21:07','2021-08-23 22:21:07'),(27,6,'Topic',18,'2021-08-23 22:23:04','2021-08-23 22:23:04'),(28,3,'Topic',18,'2021-08-23 22:26:04','2021-08-23 22:26:04'),(29,4,'Topic',18,'2021-08-23 22:30:42','2021-08-23 22:30:42'),(30,7,'Topic',18,'2021-08-24 00:00:22','2021-08-24 00:00:22'),(31,2,'Neta',18,'2021-08-24 00:01:55','2021-08-24 00:01:55'),(32,9,'Topic',18,'2021-08-24 00:09:26','2021-08-24 00:09:26'),(33,3,'Neta',18,'2021-08-24 00:09:55','2021-08-24 00:09:55'),(34,9,'Topic',9,'2021-08-24 00:17:37','2021-08-24 00:17:37'),(35,3,'Neta',9,'2021-08-24 00:17:39','2021-08-24 00:17:39'),(36,6,'Topic',9,'2021-08-24 00:19:09','2021-08-24 00:19:09'),(37,1,'Neta',9,'2021-08-24 00:19:11','2021-08-24 00:19:11'),(38,7,'Topic',9,'2021-08-24 00:20:40','2021-08-24 00:20:40'),(39,2,'Neta',9,'2021-08-24 00:20:43','2021-08-24 00:20:43'),(40,11,'Topic',18,'2021-08-24 23:38:16','2021-08-24 23:38:16'),(41,4,'Neta',18,'2021-08-24 23:44:22','2021-08-24 23:44:22'),(42,11,'Topic',15,'2021-08-24 23:48:37','2021-08-24 23:48:37'),(43,4,'Neta',15,'2021-08-24 23:48:39','2021-08-24 23:48:39'),(44,6,'Topic',15,'2021-08-25 00:16:15','2021-08-25 00:16:15'),(45,1,'Neta',15,'2021-08-25 00:16:17','2021-08-25 00:16:17'),(46,12,'Topic',15,'2021-08-25 01:44:47','2021-08-25 01:44:47'),(47,11,'Topic',16,'2021-08-25 01:49:57','2021-08-25 01:49:57'),(48,4,'Neta',16,'2021-08-25 01:50:00','2021-08-25 01:50:00'),(49,13,'Topic',16,'2021-08-25 01:59:26','2021-08-25 01:59:26'),(50,13,'Topic',18,'2021-08-25 11:55:50','2021-08-25 11:55:50'),(51,11,'Topic',6,'2021-08-25 16:00:07','2021-08-25 16:00:07'),(52,4,'Neta',6,'2021-08-25 16:00:10','2021-08-25 16:00:10'),(53,12,'Topic',15,'2021-08-26 22:37:51','2021-08-26 22:37:51'),(54,8,'Topic',15,'2021-08-27 02:27:28','2021-08-27 02:27:28'),(55,1,'Neta',18,'2021-08-29 00:46:39','2021-08-29 00:46:39'),(56,6,'Topic',18,'2021-08-29 00:46:55','2021-08-29 00:46:55'),(57,4,'Topic',18,'2021-08-29 00:47:31','2021-08-29 00:47:31'),(58,7,'Topic',9,'2021-08-29 00:58:19','2021-08-29 00:58:19'),(59,5,'Neta',9,'2021-08-29 01:01:01','2021-08-29 01:01:01'),(60,4,'Topic',9,'2021-08-29 01:01:14','2021-08-29 01:01:14'),(61,6,'Neta',9,'2021-08-29 01:10:09','2021-08-29 01:10:09'),(62,4,'Topic',7,'2021-08-29 01:32:32','2021-08-29 01:32:32'),(63,7,'Neta',7,'2021-08-29 01:34:10','2021-08-29 01:34:10'),(64,6,'Neta',7,'2021-08-29 01:35:01','2021-08-29 01:35:01'),(65,2,'Topic',7,'2021-08-29 01:39:54','2021-08-29 01:39:54'),(66,8,'Neta',7,'2021-08-29 01:41:21','2021-08-29 01:41:21'),(67,7,'Topic',7,'2021-08-29 01:41:33','2021-08-29 01:41:33'),(68,5,'Neta',7,'2021-08-29 01:41:36','2021-08-29 01:41:36'),(69,11,'Topic',7,'2021-08-29 01:42:21','2021-08-29 01:42:21'),(70,4,'Neta',7,'2021-08-29 01:42:23','2021-08-29 01:42:23'),(71,9,'Topic',7,'2021-08-29 01:42:31','2021-08-29 01:42:31'),(72,3,'Neta',7,'2021-08-29 01:42:37','2021-08-29 01:42:37'),(73,6,'Topic',7,'2021-08-29 01:43:14','2021-08-29 01:43:14'),(74,1,'Neta',7,'2021-08-29 01:43:17','2021-08-29 01:43:17'),(75,2,'Topic',4,'2021-08-29 01:48:46','2021-08-29 01:48:46'),(76,9,'Neta',4,'2021-08-29 01:49:28','2021-08-29 01:49:28'),(77,1,'Topic',1,'2021-08-29 10:51:31','2021-08-29 10:51:31'),(78,10,'Topic',9,'2021-08-29 11:13:29','2021-08-29 11:13:29'),(79,10,'Topic',17,'2021-08-29 11:13:56','2021-08-29 11:13:56'),(80,10,'Neta',9,'2021-08-29 11:21:40','2021-08-29 11:21:40'),(81,10,'Topic',18,'2021-08-29 11:34:06','2021-08-29 11:34:06'),(82,10,'Neta',18,'2021-08-29 11:34:09','2021-08-29 11:34:09'),(83,2,'Topic',18,'2021-08-29 11:36:58','2021-08-29 11:36:58'),(84,8,'Neta',18,'2021-08-29 11:37:01','2021-08-29 11:37:01'),(85,9,'Neta',18,'2021-08-29 11:39:50','2021-08-29 11:39:50'),(86,2,'Topic',9,'2021-08-29 11:42:17','2021-08-29 11:42:17'),(87,8,'Neta',9,'2021-08-29 11:42:21','2021-08-29 11:42:21'),(88,9,'Neta',9,'2021-08-29 11:45:52','2021-08-29 11:45:52'),(89,7,'Neta',9,'2021-08-29 11:48:34','2021-08-29 11:48:34'),(90,6,'Topic',9,'2021-08-29 11:51:23','2021-08-29 11:51:23'),(91,1,'Neta',9,'2021-08-29 11:51:25','2021-08-29 11:51:25'),(92,11,'Topic',15,'2021-08-29 11:53:18','2021-08-29 11:53:18'),(93,4,'Neta',15,'2021-08-29 11:53:23','2021-08-29 11:53:23'),(94,10,'Topic',15,'2021-08-29 11:53:31','2021-08-29 11:53:31'),(95,10,'Neta',15,'2021-08-29 11:53:33','2021-08-29 11:53:33'),(96,7,'Topic',18,'2021-08-29 11:58:23','2021-08-29 11:58:23'),(97,2,'Neta',18,'2021-08-29 11:58:28','2021-08-29 11:58:28'),(98,5,'Neta',18,'2021-08-29 11:58:51','2021-08-29 11:58:51'),(99,10,'Topic',15,'2021-08-31 21:10:25','2021-08-31 21:10:25'),(100,10,'Neta',15,'2021-08-31 21:10:28','2021-08-31 21:10:28'),(101,12,'Topic',15,'2021-09-06 17:14:21','2021-09-06 17:14:21'),(102,1,'Topic',15,'2021-09-06 17:14:31','2021-09-06 17:14:31'),(103,7,'Topic',15,'2021-09-06 17:14:38','2021-09-06 17:14:38'),(104,5,'Neta',15,'2021-09-06 17:14:46','2021-09-06 17:14:46'),(105,2,'Topic',15,'2021-09-06 17:15:07','2021-09-06 17:15:07'),(106,8,'Neta',15,'2021-09-06 17:15:11','2021-09-06 17:15:11'),(107,1,'Neta',18,'2021-09-07 10:01:58','2021-09-07 10:01:58'),(108,6,'Topic',18,'2021-09-07 10:02:05','2021-09-07 10:02:05'),(109,7,'Topic',18,'2021-09-07 10:02:24','2021-09-07 10:02:24'),(110,5,'Neta',18,'2021-09-07 11:04:20','2021-09-07 11:04:20'),(111,10,'Neta',18,'2021-09-07 11:05:10','2021-09-07 11:05:10'),(112,6,'Neta',18,'2021-09-07 11:05:19','2021-09-07 11:05:19'),(113,11,'Topic',18,'2021-09-07 11:25:44','2021-09-07 11:25:44'),(114,4,'Neta',18,'2021-09-08 00:46:29','2021-09-08 00:46:29'),(115,9,'Topic',12,'2021-09-08 01:59:51','2021-09-08 01:59:51'),(116,11,'Topic',3,'2021-10-03 18:30:12','2021-10-03 18:30:12'),(117,4,'Neta',3,'2021-10-03 18:30:15','2021-10-03 18:30:15'),(118,9,'Topic',18,'2021-10-03 22:57:28','2021-10-03 22:57:28'),(119,14,'Neta',18,'2021-10-03 23:34:10','2021-10-03 23:34:10'),(120,9,'Topic',3,'2021-10-03 23:35:37','2021-10-03 23:35:37'),(121,14,'Neta',3,'2021-10-03 23:35:39','2021-10-03 23:35:39'),(122,9,'Topic',15,'2021-10-03 23:54:18','2021-10-03 23:54:18'),(123,14,'Neta',15,'2021-10-03 23:54:21','2021-10-03 23:54:21');
/*!40000 ALTER TABLE `pageviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rankings`
--

DROP TABLE IF EXISTS `rankings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rankings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rankable_type` varchar(191) DEFAULT NULL,
  `rank` int(11) DEFAULT NULL,
  `rankable_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `score` float DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rankings`
--

LOCK TABLES `rankings` WRITE;
/*!40000 ALTER TABLE `rankings` DISABLE KEYS */;
/*!40000 ALTER TABLE `rankings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `neta_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `text` mediumtext,
  `rate` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_review` (`user_id`,`neta_id`),
  KEY `fk_rails_4564c578b1` (`neta_id`),
  CONSTRAINT `fk_rails_4564c578b1` FOREIGN KEY (`neta_id`) REFERENCES `netas` (`id`),
  CONSTRAINT `fk_rails_74a66bd6c5` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (1,3,9,'うちにもミッキーの耳が3つあります',3,'2021-08-24 00:18:56','2021-08-24 00:18:56'),(2,1,9,'めっちゃ扇子（センス）あるおばちゃんじゃないですか！',4,'2021-08-24 00:20:14','2021-08-24 00:20:14'),(3,2,9,'こないだオリンピックでも胸に「家族」と入ってた人いました。気持ちはわかりますけど、、ねぇ笑',3,'2021-08-24 00:24:09','2021-08-24 00:24:09'),(4,4,15,'めっちゃ頭いいお子さんだったんですね！',4,'2021-08-25 00:14:12','2021-08-25 00:14:12'),(5,1,15,'',4,'2021-08-25 00:16:32','2021-08-25 00:16:32'),(6,4,16,'子供の素直さって癒されますよね！',3,'2021-08-25 01:51:57','2021-08-25 01:51:57'),(7,6,7,'とはいえ、その前にオーバーブッキングしないでほしい…。',3,'2021-08-29 01:35:57','2021-08-29 01:35:57'),(8,5,7,'',2,'2021-08-29 01:42:01','2021-08-29 01:42:01'),(9,3,7,'',2,'2021-08-29 01:42:46','2021-08-29 01:42:46'),(10,1,7,'',4,'2021-08-29 01:43:25','2021-08-29 01:43:25'),(11,10,18,'かわいすぎます?',4,'2021-08-29 11:35:29','2021-08-29 11:35:29'),(12,8,18,'意気込むほど、ゴルフってだめなんですよね〜?',3,'2021-08-29 11:39:38','2021-08-29 11:39:38'),(13,9,18,'紳士ぶって、絶対みんなココロではそう思ってそうですよね！',3,'2021-08-29 11:40:44','2021-08-29 11:40:44'),(14,8,9,'思い通りにいかないのをいかに受け入れるかみたいなスポーツですよね！',3,'2021-08-29 11:45:12','2021-08-29 11:45:12'),(15,9,9,'実際ミスった時に、周りの心の声がたまに漏れてきますよね！',3,'2021-08-29 11:47:08','2021-08-29 11:47:08'),(16,7,9,'完全にコントじゃないですか笑',3,'2021-08-29 11:49:21','2021-08-29 11:49:21'),(17,10,15,'ほんとカワイイですね〜。パパがんばって！',3,'2021-08-29 11:55:53','2021-08-29 11:55:53'),(18,5,18,'',2,'2021-08-29 11:59:31','2021-08-29 11:59:31'),(19,5,15,'',3,'2021-09-06 17:14:51','2021-09-06 17:14:51'),(20,8,15,'',2,'2021-09-06 17:15:30','2021-09-06 17:15:30'),(21,4,3,'素直でかわいいですね！',4,'2021-10-03 22:43:11','2021-10-03 22:43:11'),(22,14,3,'もう少し笑いがほしかったです。。',2,'2021-10-03 23:45:36','2021-10-03 23:45:36'),(23,14,15,'',2,'2021-10-03 23:57:56','2021-10-03 23:57:56');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20191204084606'),('20191204094925'),('20191210094157'),('20191210133251'),('20191219163035'),('20191231043611'),('20191231071144'),('20200113091423'),('20200119044950'),('20200217061622'),('20200306143900'),('20200322122907'),('20200328171948'),('20200719062400'),('20200729064420'),('20200730031547'),('20200810044522'),('20200810051504'),('20200810072128'),('20200812140958'),('20200822065958'),('20200822171251'),('20200830063447'),('20200906055657'),('20200913171257'),('20200921073238'),('20200921154654'),('20200922061022'),('20200923162110'),('20201001162650'),('20201010075108'),('20201010081355'),('20201016064948'),('20201024140037'),('20201024141538'),('20201024142505'),('20201024142737'),('20201029160213'),('20201031152442'),('20201101160201'),('20201107133014'),('20201108031147'),('20201110155742'),('20201110160243'),('20201229155422'),('20201229160613'),('20210107144051'),('20210205134036'),('20210306130239'),('20210328014556'),('20210526021549'),('20210628033856'),('20210628035309'),('20210628035854'),('20210628040350'),('20210628040714'),('20210628040956'),('20210628041151'),('20210707021457'),('20210707023025'),('20210712062611'),('20210806144302'),('20210806151621'),('20210806155932'),('20210807141249'),('20210914074304'),('20210914124813'),('20210914150054'),('20210915071753');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stripe_accounts`
--

DROP TABLE IF EXISTS `stripe_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stripe_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `acct_id` varchar(191) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `status` varchar(191) DEFAULT NULL,
  `ext_acct_id` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_stripe_accounts_on_user_id` (`user_id`),
  UNIQUE KEY `index_stripe_accounts_on_acct_id` (`acct_id`),
  UNIQUE KEY `index_stripe_accounts_on_ext_acct_id` (`ext_acct_id`),
  CONSTRAINT `fk_rails_764fb7bcbe` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stripe_accounts`
--

LOCK TABLES `stripe_accounts` WRITE;
/*!40000 ALTER TABLE `stripe_accounts` DISABLE KEYS */;
INSERT INTO `stripe_accounts` VALUES (1,18,'acct_1JRf7SRCqRPv2EJa','2021-08-24 00:31:28','2021-08-24 01:20:38','verified','ba_1JRft2RCqRPv2EJapuX2Gt7y');
/*!40000 ALTER TABLE `stripe_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stripe_idcards`
--

DROP TABLE IF EXISTS `stripe_idcards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stripe_idcards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stripe_account_id` int(11) DEFAULT NULL,
  `frontback` varchar(191) DEFAULT NULL,
  `stripe_file_id` varchar(191) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_idcard` (`stripe_account_id`,`frontback`),
  CONSTRAINT `fk_rails_9fb741a54d` FOREIGN KEY (`stripe_account_id`) REFERENCES `stripe_accounts` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stripe_idcards`
--

LOCK TABLES `stripe_idcards` WRITE;
/*!40000 ALTER TABLE `stripe_idcards` DISABLE KEYS */;
INSERT INTO `stripe_idcards` VALUES (1,1,'front','file_1JRfbJEThOtNwrS9DxNcIgYy','2021-08-24 01:02:18','2021-08-24 01:02:18');
/*!40000 ALTER TABLE `stripe_idcards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stripe_payouts`
--

DROP TABLE IF EXISTS `stripe_payouts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stripe_payouts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stripe_account_id` int(11) DEFAULT NULL,
  `payout_id` varchar(191) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `amount` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_stripe_payouts_on_payout_id` (`payout_id`),
  KEY `fk_rails_981e366b28` (`stripe_account_id`),
  CONSTRAINT `fk_rails_981e366b28` FOREIGN KEY (`stripe_account_id`) REFERENCES `stripe_accounts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stripe_payouts`
--

LOCK TABLES `stripe_payouts` WRITE;
/*!40000 ALTER TABLE `stripe_payouts` DISABLE KEYS */;
/*!40000 ALTER TABLE `stripe_payouts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topics`
--

DROP TABLE IF EXISTS `topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `topics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(191) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `pageviews_count` int(11) NOT NULL DEFAULT '0',
  `likes_count` int(11) NOT NULL DEFAULT '0',
  `bookmarks_count` int(11) NOT NULL DEFAULT '0',
  `netas_count` int(11) NOT NULL DEFAULT '0',
  `comments_count` int(11) NOT NULL DEFAULT '0',
  `private_flag` tinyint(1) NOT NULL DEFAULT '0',
  `header_img_url` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_topics_on_title` (`title`),
  KEY `fk_rails_7b812cfb44` (`user_id`),
  CONSTRAINT `fk_rails_7b812cfb44` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topics`
--

LOCK TABLES `topics` WRITE;
/*!40000 ALTER TABLE `topics` DISABLE KEYS */;
INSERT INTO `topics` VALUES (1,'高級レストラン',1,'2021-07-13 00:32:03','2021-08-29 10:57:06',8,1,0,0,0,0,'//teppan-stage.s3.ap-northeast-1.amazonaws.com/topic_header_images/314cb141-d5a1-4f57-88b2-c4020da60372/bistroQtableset.jpeg'),(2,'ゴルフネタ',9,'2021-08-21 15:38:13','2021-08-21 15:49:47',6,0,0,2,0,0,'//teppan-stage.s3.ap-northeast-1.amazonaws.com/topic_header_images/787b72c9-161c-4171-a1b0-2ced92c35c84/839D42AC-CD19-48B1-A725-FA19EE6B1784.jpeg'),(3,'野球ネタ',7,'2021-08-21 15:55:12','2021-08-21 16:01:23',2,0,0,0,0,0,'//teppan-stage.s3.ap-northeast-1.amazonaws.com/topic_header_images/5f5df4af-5a87-4ec0-9bfd-672832c4e3bf/C1050C5B-7305-43A8-BFBF-EE9524B47D45.jpeg'),(4,'空港・飛行機',5,'2021-08-21 16:07:43','2021-08-21 16:13:30',6,0,0,2,0,0,'//teppan-stage.s3.ap-northeast-1.amazonaws.com/topic_header_images/b4339a8b-dda5-4854-8b87-65896c029fbe/9EA6EE69-1513-4B70-8724-8F314279D390.jpeg'),(5,'ドライブ・運転',13,'2021-08-21 16:22:01','2021-08-21 16:22:01',1,0,0,0,0,1,NULL),(6,'お正月',11,'2021-08-21 23:46:30','2021-08-21 23:50:10',11,1,1,1,0,0,'//teppan-stage.s3.ap-northeast-1.amazonaws.com/topic_header_images/95d3b15d-ede5-4ea4-ab7b-7c12554a5304/お正月.jpeg'),(7,'ハワイ',10,'2021-08-21 23:54:50','2021-08-21 23:59:20',8,0,0,2,0,0,'//teppan-stage.s3.ap-northeast-1.amazonaws.com/topic_header_images/cdc07e21-aeb3-439d-8997-a96535f70435/9CDB88E5-653B-4C91-9FC3-0E5CCB996C71.jpeg'),(8,'オリンピック',6,'2021-08-22 00:10:35','2021-08-22 00:15:09',4,0,1,0,0,0,'//teppan-stage.s3.ap-northeast-1.amazonaws.com/topic_header_images/730ef414-c1a5-46db-81ba-0f88e472cb8e/olympic2.jpeg'),(9,'ディズニーランド・シー',12,'2021-08-22 00:21:22','2021-08-22 00:30:12',10,0,0,2,0,0,'//teppan-stage.s3.ap-northeast-1.amazonaws.com/topic_header_images/1de96797-053d-4286-9a38-c9f34abba70b/tdl.jpeg'),(10,'育児',17,'2021-08-22 09:23:56','2021-08-29 11:14:25',6,0,1,1,0,0,'//teppan-stage.s3.ap-northeast-1.amazonaws.com/topic_header_images/50803946-fac2-42d6-8e5d-04ca5da1eb1c/4EB499D9-6565-4E83-ADA5-06E1C6BFAB7E.jpeg'),(11,'車・運転',18,'2021-08-22 09:37:22','2021-08-22 09:56:56',9,0,1,1,0,0,'//teppan-stage.s3.ap-northeast-1.amazonaws.com/topic_header_images/78a74b55-267c-4f89-803c-448658f061fc/5036866_m.jpg'),(12,'就活',15,'2021-08-25 01:41:44','2021-08-26 22:38:06',3,0,0,0,0,0,'//teppan-stage.s3.ap-northeast-1.amazonaws.com/topic_header_images/d71ace96-6e37-4466-b034-8410104fd49a/shuukatsu.jpeg'),(13,'美術館',16,'2021-08-25 01:54:55','2021-08-25 01:59:37',2,0,0,0,0,0,'//teppan-stage.s3.ap-northeast-1.amazonaws.com/topic_header_images/c9711114-a0e0-4bbd-ac5e-e76d63063ce2/49635AF9-38BB-4133-BF9B-E8261401D49F.jpeg');
/*!40000 ALTER TABLE `topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trades`
--

DROP TABLE IF EXISTS `trades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `buyer_id` int(11) NOT NULL DEFAULT '0',
  `price` int(11) NOT NULL DEFAULT '0',
  `tradetype` varchar(191) DEFAULT NULL,
  `tradestatus` varchar(191) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `tradeable_id` int(11) NOT NULL DEFAULT '0',
  `tradeable_type` varchar(191) NOT NULL DEFAULT '0',
  `seller_id` int(11) NOT NULL DEFAULT '0',
  `stripe_ch_id` varchar(191) DEFAULT NULL,
  `stripe_pi_id` varchar(191) DEFAULT NULL,
  `seller_revenue` int(11) DEFAULT NULL,
  `fee` int(11) DEFAULT NULL,
  `c_tax` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_trade` (`buyer_id`,`seller_id`,`tradeable_type`,`tradeable_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trades`
--

LOCK TABLES `trades` WRITE;
/*!40000 ALTER TABLE `trades` DISABLE KEYS */;
INSERT INTO `trades` VALUES (1,15,100,NULL,NULL,'2021-08-25 00:10:12','2021-08-25 00:10:12',4,'Neta',18,'ch_3JS1FfEThOtNwrS90kTv4t7d','pi_3JS1FfEThOtNwrS90rDoqs3T',85,15,10),(2,16,100,NULL,NULL,'2021-08-25 01:50:54','2021-08-25 01:50:54',4,'Neta',18,'ch_3JS2p8EThOtNwrS901Xf4MzL','pi_3JS2p8EThOtNwrS90IHlpDgY',85,15,10),(3,3,100,NULL,NULL,'2021-10-03 18:30:58','2021-10-03 18:30:58',4,'Neta',18,'ch_3JgR1REThOtNwrS91kSLZ0gq','pi_3JgR1REThOtNwrS91JXNIuTa',82,18,10),(4,3,150,NULL,NULL,'2021-10-03 23:36:12','2021-10-03 23:36:12',14,'Neta',18,'ch_3JgVn0EThOtNwrS90TLOanAF','pi_3JgVn0EThOtNwrS90b0NSKLl',123,27,15),(5,15,150,NULL,NULL,'2021-10-03 23:55:27','2021-10-03 23:55:27',14,'Neta',18,'ch_3JgW57EThOtNwrS91J0nV5Bq','pi_3JgW57EThOtNwrS91FfisKbF',123,27,15);
/*!40000 ALTER TABLE `trades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `encrypted_password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `reset_password_token` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `nickname` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `gender` int(11) DEFAULT NULL,
  `stripe_cus_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `followers_count` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `confirmation_token` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `confirmation_sent_at` datetime DEFAULT NULL,
  `unconfirmed_email` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sign_in_count` int(11) NOT NULL DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_sign_in_ip` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unregistered` tinyint(1) NOT NULL DEFAULT '0',
  `provider` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `uid` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar_img_url` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `followings_count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`),
  UNIQUE KEY `index_users_on_confirmation_token` (`confirmation_token`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'rnuka99@gmail.com','$2a$11$tzy48N3GKaI8O6LmoF8nwe3rPGJZglQPAh/OWmEdoiFnkI/x9B2ze',NULL,NULL,NULL,'Ryotaro','1980-02-27',1,NULL,0,'2021-07-12 16:18:38.318497','2021-10-03 17:40:04.786930',NULL,'2021-07-12 16:18:38',NULL,NULL,6,'2021-10-03 17:40:04','2021-09-07 09:58:11','175.177.44.126','175.177.44.117',0,'google_oauth2','107785992881117695488','//teppan-stage.s3.ap-northeast-1.amazonaws.com/user_avatar_images/3e46d6e1-2899-4f30-9698-444e975e2784/avatar.png',0),(2,'ryohei@twitter-hoge.com','$2a$11$zZZoAMoR4vjPQa2RaYiq/OZW32DiEHpCuwQdfnqqFUGVR2QJCcnpa',NULL,NULL,NULL,'ryohei',NULL,NULL,NULL,0,'2021-07-14 17:18:35.397487','2021-10-03 18:27:48.881624',NULL,'2021-07-14 17:18:35',NULL,NULL,3,'2021-10-03 18:27:48','2021-07-19 18:58:30','175.177.44.126','219.120.29.145',0,'twitter','917213617396649986',NULL,0),(3,'ryo_n_1104@yahoo.co.jp','$2a$11$3ffQRoSV2e.4YuPqLZ.ilOtMby6ojqz7VRxKsQR0GRBCG70VA61ma',NULL,NULL,NULL,'怒賀良平',NULL,1,'cus_KL7Go9G9v4y1XI',0,'2021-07-19 18:58:06.115459','2021-10-03 23:35:32.794271',NULL,'2021-07-19 18:58:06',NULL,NULL,6,'2021-10-03 23:35:32','2021-10-03 22:41:28','175.177.44.112','175.177.44.112',0,'yahoojp','OCNBBKAX64GEHHKRSD2FKEKX6Y',NULL,0),(4,'toru@hogehoge.com','$2a$11$pohO/tl3cdn/38fEDoz7Qu4Jvfn0kji2v1SkLXOGaK4GkGgcA544y',NULL,NULL,NULL,'Toru1221','1982-05-21',NULL,NULL,0,'2021-08-21 01:18:31.260260','2021-08-29 01:48:39.651041',NULL,'2021-08-20 17:06:01',NULL,NULL,2,'2021-08-29 01:48:39','2021-08-21 01:18:31','175.177.44.121','175.177.44.124',0,NULL,NULL,NULL,0),(5,'hayato@hogehoge.com','$2a$11$vF/UuggiRJyHXFkY0Vx6Nu6Vd/AqUkmkb7x/bUoYth71ShveDJJze',NULL,NULL,NULL,'ハヤト','2005-08-10',NULL,NULL,0,'2021-08-21 01:21:25.678891','2021-08-21 16:04:04.666852',NULL,'2021-08-20 17:06:01',NULL,NULL,2,'2021-08-21 16:04:04','2021-08-21 01:21:25','175.177.44.114','175.177.44.124',0,NULL,NULL,NULL,0),(6,'tetsuya@hogehoge.com','$2a$11$0AZGJtvi64n4C3UdmezkbOI513jaQGYRem0nhVssZ8N7fb.SsQ9Pa',NULL,NULL,NULL,'てつや','1980-10-21',NULL,NULL,0,'2021-08-21 01:24:35.894262','2021-08-25 15:59:31.818076',NULL,'2021-08-20 17:06:01',NULL,NULL,3,'2021-08-25 15:58:38','2021-08-22 00:07:33','175.177.44.125','175.177.44.119',0,NULL,NULL,'//teppan-stage.s3.ap-northeast-1.amazonaws.com/user_avatar_images/ddf4528d-da42-4c94-b32e-5feacd607c07/パンダ.jpeg',0),(7,'keisuke@hogehoge.com','$2a$11$YkpxMKCQ2CiVI.uHzdFiXukbilV.RSf5xpJz.N4yrlE8vnT1sK706',NULL,NULL,NULL,'ケイスケ','1987-08-21',NULL,NULL,0,'2021-08-21 01:26:30.314743','2021-08-29 01:32:26.804981',NULL,'2021-08-20 17:06:01',NULL,NULL,3,'2021-08-29 01:32:26','2021-08-21 15:51:59','175.177.44.121','175.177.44.114',0,NULL,NULL,NULL,0),(8,'satoshi@hogehoge.com','$2a$11$WL0EQRGqgoukXC0X68AJNuKVQSmsX.emWkVblrNGaTY.TLCu8HGiC',NULL,NULL,NULL,'サトシ','1983-12-21',NULL,NULL,0,'2021-08-21 01:37:19.258716','2021-08-25 14:09:57.412031',NULL,'2021-08-20 17:06:01',NULL,NULL,2,'2021-08-25 14:03:09','2021-08-21 01:37:19','175.177.44.119','175.177.44.124',0,NULL,NULL,'//teppan-stage.s3.ap-northeast-1.amazonaws.com/user_avatar_images/47638eae-eec2-4030-814c-8218e07a6aa5/5F133A95-7EC7-4A3B-AADE-0C49A54DA454.png',0),(9,'yosuke@hogehoge.com','$2a$11$CO/YXCcl9V9MYRXXibD9FOZ/MT9Ml5Li3AGgF07DRHSObXahfshSi',NULL,NULL,NULL,'yosuke','2000-08-21',1,NULL,0,'2021-08-21 01:39:39.682486','2021-08-29 11:15:03.316548',NULL,'2021-08-20 17:06:01',NULL,NULL,6,'2021-08-29 11:15:03','2021-08-29 10:58:34','175.177.44.116','175.177.44.116',0,NULL,NULL,'//teppan-stage.s3.ap-northeast-1.amazonaws.com/user_avatar_images/277e7300-23d2-429a-b78c-a1a4d606a0de/フクロウ.jpeg',0),(10,'hiroyuki@hogehoge.com','$2a$11$i1/H640fMBa7Ni1MlkGgOumc.YBoB0aQteX4F7V2bAXDzF3ktQwQm',NULL,NULL,NULL,'ひろゆき','1978-08-21',NULL,NULL,0,'2021-08-21 01:41:04.004291','2021-08-21 23:56:20.222526',NULL,'2021-08-20 17:06:01',NULL,NULL,3,'2021-08-21 23:56:20','2021-08-21 23:53:11','175.177.44.112','175.177.44.119',0,NULL,NULL,NULL,0),(11,'masaki@hogehoge.com','$2a$11$4d319xMoa6WDeZOopzZjx.CqjsCKAPnPXKQcAT5HEyY9HKHZQegSK',NULL,NULL,NULL,'まさき?','1987-05-21',NULL,NULL,0,'2021-08-21 01:42:57.700990','2021-08-21 23:39:20.472582',NULL,'2021-08-20 17:06:01',NULL,NULL,2,'2021-08-21 23:39:20','2021-08-21 01:42:57','175.177.44.119','175.177.44.124',0,NULL,NULL,NULL,0),(12,'atsushi@hogehoge.com','$2a$11$65FHPxzP/HZjTNH/ikzCv.CjS9m8jMr5XT/16IhCifPBUfd9gm4bW',NULL,NULL,NULL,'Atsushi','1976-10-21',1,NULL,0,'2021-08-21 01:44:48.890251','2021-09-08 01:59:14.676747',NULL,'2021-08-20 17:06:01',NULL,NULL,4,'2021-09-08 01:59:14','2021-08-25 14:33:20','175.177.44.127','175.177.44.119',0,NULL,NULL,'//teppan-stage.s3.ap-northeast-1.amazonaws.com/user_avatar_images/795b7f7f-5362-4acc-8fa3-0c29920a8b22/E3EF08F2-73C3-4A14-8725-096CDF2CBF1B.jpeg',0),(13,'shohei@hogehoge.com','$2a$11$HqL6XjCuzPYZMDTqyDEsi.9pvHXfp3hsH1RNHXZfsjSkWLAcOjrUW',NULL,NULL,NULL,'しょーへい','1973-06-21',NULL,NULL,0,'2021-08-21 01:47:29.718639','2021-08-21 16:17:42.790849',NULL,'2021-08-20 17:06:01',NULL,NULL,2,'2021-08-21 16:17:42','2021-08-21 01:47:29','175.177.44.114','175.177.44.124',0,NULL,NULL,NULL,0),(14,'yasuhiro@hogehoge.com','$2a$11$DpmV.XHRI.QxWzRP1A3.OOCQ0skxDN8MocP0dfeFdQaV7fw6If0pC',NULL,NULL,NULL,'Yasu','1987-08-21',NULL,NULL,0,'2021-08-21 01:49:23.632832','2021-08-21 01:49:39.773574',NULL,'2021-08-20 17:06:01',NULL,NULL,1,'2021-08-21 01:49:23','2021-08-21 01:49:23','175.177.44.124','175.177.44.124',0,NULL,NULL,NULL,0),(15,'hideto@hogehoge.com','$2a$11$/7Tu8nx4qGksIwq8kXCpXefuHapTiYAH/lcgX8QowWpJo4C9R93z2',NULL,NULL,NULL,'ヒデ','1984-08-21',NULL,'cus_K6Dh9qwL1jORG1',0,'2021-08-21 01:50:21.203707','2021-10-03 23:54:11.094807',NULL,'2021-08-20 17:06:01',NULL,NULL,5,'2021-10-03 23:54:11','2021-08-29 11:52:38','175.177.44.112','175.177.44.116',0,NULL,NULL,'//teppan-stage.s3.ap-northeast-1.amazonaws.com/user_avatar_images/757ea756-4a1e-4740-a121-9d6c48d35af6/トラ.png',0),(16,'teppei@hogehoge.com','$2a$11$pjNX3BaHXkrSB8RWYgyIH.ynfDkFKXyL1C4cbxbSgATSYKWQXgfKu',NULL,NULL,NULL,'てっぺい','1986-12-21',NULL,'cus_K6FKNcYuBEKelr',0,'2021-08-21 14:56:42.331871','2021-08-25 01:50:53.976284',NULL,'2021-08-21 06:05:33',NULL,NULL,2,'2021-08-25 01:49:45','2021-08-21 14:56:42','175.177.44.113','175.177.44.117',0,NULL,NULL,NULL,0),(17,'masato@hogehoge.com','$2a$11$qzWAVF/h10IDneQrCPFkPObYkdzvSzPIIXzyct1teinZHS0IB7sHe',NULL,NULL,NULL,'マサト','1987-03-21',NULL,NULL,0,'2021-08-21 14:58:35.438640','2021-08-29 11:13:52.671599',NULL,'2021-08-21 06:05:33',NULL,NULL,3,'2021-08-29 11:13:52','2021-08-22 09:19:36','175.177.44.116','175.177.44.114',0,NULL,NULL,NULL,0),(18,'koutaro@hogehoge.com','$2a$11$ySHDgjY4WWvQ1Zx1dUu6WurvE7qdll1kzKAC.WS/aa1FQzp/y2oQu',NULL,NULL,NULL,'コータロー','1980-10-21',NULL,NULL,0,'2021-08-21 15:00:39.603849','2021-10-04 10:54:20.681258',NULL,'2021-08-21 06:05:33',NULL,NULL,9,'2021-10-04 10:54:20','2021-10-03 22:44:30','175.177.44.115','175.177.44.112',0,NULL,NULL,'//teppan-stage.s3.ap-northeast-1.amazonaws.com/user_avatar_images/f78c0b50-3e6d-46fa-8242-92116291266b/337D3AF6-1BE3-4702-91D6-04B04F217301.jpeg',0),(19,'makoto@hogehoge.com','$2a$11$f77SZigUBiHcO7fGbNDkqOqduyJbmRQ7E0rBjh5QWe2eUxrJPtzQe',NULL,NULL,NULL,'まこと','1983-10-21',NULL,NULL,0,'2021-08-21 15:02:42.768779','2021-08-21 15:03:02.940546',NULL,'2021-08-21 06:05:33',NULL,NULL,1,'2021-08-21 15:02:42','2021-08-21 15:02:42','175.177.44.117','175.177.44.117',0,NULL,NULL,NULL,0),(20,'kentarou@hogehoge.com','$2a$11$SU9xfvTC/Sdjb9W273ORiOiV/rN53Zm8/AvNtlEtvJ/aynachJeYW',NULL,NULL,NULL,'ケンタロー','1993-06-21',NULL,NULL,0,'2021-08-21 15:04:07.436934','2021-08-21 15:04:23.004266',NULL,'2021-08-21 06:05:33',NULL,NULL,1,'2021-08-21 15:04:07','2021-08-21 15:04:07','175.177.44.117','175.177.44.117',0,NULL,NULL,NULL,0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `violations`
--

DROP TABLE IF EXISTS `violations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `violations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `reporter_id` int(11) NOT NULL DEFAULT '0',
  `text` mediumtext,
  `block` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_violation` (`user_id`,`reporter_id`),
  CONSTRAINT `fk_rails_3524b5b059` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `violations`
--

LOCK TABLES `violations` WRITE;
/*!40000 ALTER TABLE `violations` DISABLE KEYS */;
/*!40000 ALTER TABLE `violations` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-10-19 14:14:24
