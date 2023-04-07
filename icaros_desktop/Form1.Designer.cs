
namespace icaros_desktop
{
    partial class Form1
    {
        /// <summary>
        /// Variável de designer necessária.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Limpar os recursos que estão sendo usados.
        /// </summary>
        /// <param name="disposing">true se for necessário descartar os recursos gerenciados; caso contrário, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Código gerado pelo Windows Form Designer

        /// <summary>
        /// Método necessário para suporte ao Designer - não modifique 
        /// o conteúdo deste método com o editor de código.
        /// </summary>
        private void InitializeComponent()
        {
            this.titulo = new System.Windows.Forms.Label();
            this.qrcode = new System.Windows.Forms.Panel();
            this.local_ip = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // titulo
            // 
            this.titulo.AutoSize = true;
            this.titulo.Font = new System.Drawing.Font("Microsoft Sans Serif", 30F);
            this.titulo.Location = new System.Drawing.Point(322, 42);
            this.titulo.Name = "titulo";
            this.titulo.Size = new System.Drawing.Size(129, 46);
            this.titulo.TabIndex = 0;
            this.titulo.Text = "Icaros";
            // 
            // qrcode
            // 
            this.qrcode.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.qrcode.Location = new System.Drawing.Point(113, 155);
            this.qrcode.Name = "qrcode";
            this.qrcode.Size = new System.Drawing.Size(198, 198);
            this.qrcode.TabIndex = 1;
            // 
            // local_ip
            // 
            this.local_ip.AutoSize = true;
            this.local_ip.Font = new System.Drawing.Font("Microsoft Sans Serif", 60F);
            this.local_ip.Location = new System.Drawing.Point(415, 200);
            this.local_ip.Name = "local_ip";
            this.local_ip.Size = new System.Drawing.Size(249, 91);
            this.local_ip.TabIndex = 2;
            this.local_ip.Text = "label1";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.local_ip);
            this.Controls.Add(this.qrcode);
            this.Controls.Add(this.titulo);
            this.Name = "Form1";
            this.Text = "Form1";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label titulo;
        private System.Windows.Forms.Panel qrcode;
        private System.Windows.Forms.Label local_ip;
    }
}

