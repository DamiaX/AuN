About:<blockquote>
**Arch-Update-Notifier** is a program to automatically check for system updates for **Arch Linux**
</blockquote>
<hr>
Features:<br>
<blockquote>
* Autostart.<br>
* Automatically checking updates.<br>
* Notifications about new updates.<br>
* Automatic updates Arch-Update-Notifier.<br>
* The translations (Polish and English).<br>
* Automatically install updates.<br>

</blockquote>
<hr>
GUI Install:<br>
<blockquote>
Download this: https://raw.githubusercontent.com/DamiaX/AuN/master/Arch-Update-Notifier file.<br>
Give permissions to run.
Run this file on terminal.
</blockquote>
<hr>
Terminal Install:<br>
<blockquote>
Step 1: Download (Method 1/2: Use <code>wget</code> to download a install script and give permissions to run)
<pre><code>wget https://raw.githubusercontent.com/DamiaX/AuN/master/Arch-Update-Notifier -O AuN; 
chmod +x AuN</code></pre>

Step 1: Download (Method 2/2: Use <code>curl</code> to download a install script and give permissions to run)
<pre><code>curl https://raw.githubusercontent.com/DamiaX/AuN/master/Arch-Update-Notifier > AuN;
chmod +x AuN</code></pre>

Step 2: Run the <code>AuN</code> script.
<pre><code>./AuN</code></pre>
</blockquote>
<hr>
Uninstall Arch-Update-Notifier:<br>
<blockquote>
Method 1: Manually uninstalling the program files.<br>
<code>sudo rm -rf ~/.config/autostart/aun-run.desktop</code> removing autostart applications.<br>
<code>sudo rm -rf /usr/local/sbin/arch-update*</code> removing the application<br>
<code>sudo rm -rf /usr/local/sbin/aun-*</code> removing the application<br>
<code>sudo rm -rf $HOME/.AuN_data</code> removing configuration files.<br>
      
Method 2: Starting automatic uninstaller<br>
<code>sudo arch-update -r</code><br>
</blockquote>
<hr>
Advanced usage examples and notes:<blockquote>
<code>-h</code> or <code>--help</code> view the content of help.<br>
<code>-v</code> or <code>--version</code> display the version of the program.<br>
<code>-u</code> or <code>--update</code> check the available program updates.<br>
<code>-r</code> or <code>--remove</code> remove application.<br>
<code>-c</code> or <code>--copy</code> install program.<br>
<code>-ts</code> or <code>--time-setting</code> change the search time settings for new updates.<br>
<code>-ai</code> or <code>--auto-install</code> settings for automatic updates.<br>
<code>-a</code> or <code>--author</code> display information about the author of the program.<br>

</blockquote>
<hr>
Author:<br>
<blockquote>
Damian Majchrzak (https://www.facebook.com/DamiaX).
</blockquote>
