#ifndef _GSTPJNATHSRC_H
#define _GSTPJNATHSRC_H

#include <gst/gst.h>
#include <gst/base/gstpushsrc.h>
#include <pjlib.h>
#include <pjlib-util.h>
#include <pjnath.h>

G_BEGIN_DECLS
#define PJNATH_TYPE pjnath_get_type()
#define GST_TYPE_PJNATH_SRC \
(gst_pjnath_src_get_type())
#define GST_PJNATH_SRC(obj) \
(G_TYPE_CHECK_INSTANCE_CAST((obj),GST_TYPE_PJNATH_SRC,GstpjnathSrc))
#define GST_PJNATH_SRC_CLASS(klass) \
(G_TYPE_CHECK_CLASS_CAST((klass),GST_TYPE_PJNATH_SRC,GstpjnathSrcClass))
#define GST_IS_PJNATH_SRC(obj) \
(G_TYPE_CHECK_INSTANCE_TYPE((obj),GST_TYPE_PJNATH_SRC))
#define GST_IS_PJNATH_SRC_CLASS(klass) \
(G_TYPE_CHECK_CLASS_TYPE((klass),GST_TYPE_PJNATH_SRC))
typedef struct _GstpjnathSrc GstpjnathSrc;

struct _GstpjnathSrc
{
  GstPushSrc parent;
  GstPad *srcpad;

  pj_ice_strans *icest;
  guint comp_id;
  pj_sockaddr *def_addr;

  GMainContext *mainctx;
  GMainLoop *mainloop;
  GQueue *outbufs;
  gboolean unlocked;
  GSource *idle_source;
};

typedef struct _GstpjnathSrcClass GstpjnathSrcClass;

struct _GstpjnathSrcClass
{
  GstPushSrcClass parent_class;
};

GType gst_pjnath_src_get_type (void);

void gst_cb_on_rx_data (pj_ice_strans * ice_st,
    unsigned comp_id,
    void *pkt, pj_size_t size,
    const pj_sockaddr_t * src_addr,
    unsigned src_addr_len);
G_END_DECLS
#endif // _GSTpjnathSRC_H
